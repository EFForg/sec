//= require react-sortable-hoc/dist/umd/react-sortable-hoc.js

const {SortableContainer, SortableElement, SortableHandle, arrayMove} = SortableHOC;

const LessonPlan = createReactClass({
  getInitialState: function() {
    return {
      lessons_count: this.props.lessons_count,
      duration_in_words: this.props.duration_in_words,
      lessons: this.props.lessons,
      share: false
    };
  },

  persistLessonPlan: function(data) {
    var self = this;
    $.ajax({
      type: "PATCH",
      url: `/lesson-plans/${self.props.id}`,
      data: { lesson_plan: data }
    }).success((res) => {
      self.setState({
        lessons_count: res.lessons_count,
        duration_in_words: res.duration_in_words,
        lessons: res.lessons
      });
    });
  },

  reorderLessons: function({oldIndex, newIndex}) {
    const reordered_lessons = arrayMove(this.state.lessons, oldIndex, newIndex);

    // Optimistically update during AJAX
    this.setState({
      lessons: reordered_lessons
    });

    this.persistLessonPlan({
      lesson_plan_lessons_attributes: reordered_lessons.map((el, index) => {
        return {
          id: el.id,
          position: index
        }
      })
    });
  },

  removeLesson: function(e, lesson) {
    this.persistLessonPlan({
      lesson_plan_lessons_attributes: {
        id: lesson.id,
        _destroy: true
      }
    });

    e.preventDefault();
  },

  toggleShare: function(e) {
    this.setState({ share: !this.state.share });
    e.preventDefault();
  },

  render: function() {
    var props = this.props;
    var state = this.state;

    const noLessonsMarkup = (
      <div className="lessons">
        <p>
          It looks like you have not added any lessons to your Lesson Planner.
        </p>
        <p>
          Go to <a href="/topics">LESSONS</a> to start choosing which lessons you would like to include.
        </p>
      </div>
    );

    const lessonsMarkup = (
      <div>
        <div className="total-duration">
          Total duration: {state.duration_in_words}
        </div>
        <LessonsList lessons={state.lessons} planId={props.id} onRemove={this.removeLesson}
          onSortEnd={this.reorderLessons} useDragHandle={true} />
      </div>
    );

    return (
      <div className="lesson-plan">
        <div className="export">
          <a href={props.links.pdf}>Print</a>
          <a href={props.links.zip}>Download</a>
          <a href={props.links.share} onClick={this.toggleShare}>Share</a>
          { this.state.share && <input type="text" value={props.links.share} readOnly={true} /> }
        </div>
        <div className="your-lessons">
          Your lessons ({state.lessons_count})
        </div>

        {(state.lessons_count > 0) ? lessonsMarkup : noLessonsMarkup}
      </div>
    );
  }
});

const LessonsList = SortableContainer(({planId, lessons, onRemove}) => {
  return (
    <ul className="lessons">
      {lessons.map((lesson, index) =>
        <SortableLesson {...lesson} key={lesson.id} index={index} planId={planId}
          onRemove={(e) => onRemove(e, lesson)} />
      )}
    </ul>
  );
});

const LessonHandle = SortableHandle(() => {
  return (
    <div className="handle">
      <i className="fa fa-bars" />
      Drag to reorder
    </div>
  );
});

const SortableLesson = SortableElement((props) => <Lesson {...props} /> );

const Lesson = createReactClass({
  getInitialState: function() {
    return { draggable: false };
  },

  componentDidMount: function() {
    requestAnimationFrame(() => {
      this.setState({ draggable: true });
    });
  },

  render: function() {
    const props = this.props;

    return (
      <li className="lesson card">
        <div className="top">
          <div className="icon" dangerouslySetInnerHTML={{__html: props.rendered_icon}} />
          <h3>{props.name}</h3>
          <div className="duration">Duration: {props.duration}</div>
          <div className="levels" dangerouslySetInnerHTML={{__html: props.difficulty_tag}} />
          { this.state.draggable && <LessonHandle /> }
          <RemoveLessonForm id={props.id} planId={props.planId} onRemove={props.onRemove} />
        </div>
      </li>
    );
  }
});

const RemoveLessonForm = createReactClass({
  render: function() {
    const action = `/lesson-plans/${this.props.planId}`;

    return (
      <form action={action} method="post" onSubmit={this.props.onRemove}>
        <input type="hidden" name="_method" value="patch" />
        <input name="lesson_plan[lesson_plan_lessons_attributes][0][_destroy]"
          type="hidden" value="true" />
        <input name="lesson_plan[lesson_plan_lessons_attributes][0][id]"
          type="hidden" value={this.props.id} />
        <input type="submit" className="remove-lesson" value="Remove this lesson" />
      </form>
    );
  }
})
