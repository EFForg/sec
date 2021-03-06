//= require react-sortable-hoc/dist/umd/react-sortable-hoc.js

const {SortableContainer, SortableElement, SortableHandle, arrayMove} = SortableHOC;

const LessonPlan = createReactClass({
  getInitialState: function() {
    return {
      lessons_count: this.props.lessons_count,
      duration_in_words: this.props.duration_in_words,
      lessons: this.props.lessons,
      share_link: this.props.links.share
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
        lessons: res.lessons,
        share_link: res.links.share
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
      planned_lessons_attributes: reordered_lessons.map((el, index) => {
        return {
          id: el.id,
          position: index
        }
      })
    });
  },

  removeLesson: function(e, lesson) {
    this.persistLessonPlan({
      planned_lessons_attributes: {
        id: lesson.id,
        _destroy: true
      }
    });

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
        <ExportLinks links={props.links} share_link={this.state.share_link} />
        <LessonsList
          lessons={state.lessons}
          planId={props.id}
          shared={props.shared}
          onRemove={this.removeLesson}
          onSortEnd={this.reorderLessons}
          useDragHandle={false}
          distance={5} />
      </div>
    );

    return (
      <div className="lesson-plan">
        <div className="your-lessons">
          Your lessons ({state.lessons_count})
        </div>

        {(state.lessons_count > 0) ? lessonsMarkup : noLessonsMarkup}
      </div>
    );
  }
});

const ExportLinks = createReactClass({
  getInitialState: function() {
    return {
      share: false
    };
  },

  toggleShare: function(e) {
    this.setState({ share: !this.state.share }, function() {
      this.state.share && this.refs.input.select();
    });
    if (!e.ctrlKey && !e.shiftKey && !e.altKey && !e.metaKey) {
      e.preventDefault();
    }
  },

  render: function() {
    return (
      <div className="export">
        <a href={this.props.links.pdf}>Print</a>
        <a href={this.props.links.zip}>Download</a>
        <a href={this.props.share_link} onClick={this.toggleShare}>Share</a>
        { this.state.share &&
          <div className="copy-share-link">
            <input type="text" value={this.props.share_link} ref="input" readOnly={true} />
          </div>
        }
      </div>
    );
  }
});

const LessonsList = SortableContainer((props) => {
  return (
    <ul className="lessons">
      {props.lessons.map((lesson, index) =>
        <SortableLesson {...lesson} key={lesson.id} index={index} planId={props.planId}
          shared={props.shared} onRemove={(e) => props.onRemove(e, lesson)} />
      )}
    </ul>
  );
});

const SortableLesson = SortableElement((props) => <Lesson {...props} /> );

const Lesson = createReactClass({
  getInitialState: function() {
    return { draggable: false };
  },

  componentDidMount: function() {
    requestAnimationFrame(() => {
      this.setState({ draggable: !this.props.shared });
    });
  },

  render: function() {
    const props = this.props;

    return (
      <li className="lesson card">
        <div className="top">
          <div className="icon" dangerouslySetInnerHTML={{__html: props.rendered_icon}} />
          <h3>
            <a href={props.path}>{props.name}</a>
          </h3>
          <div className="duration">Duration: {props.duration}</div>
          <div className="levels" dangerouslySetInnerHTML={{__html: props.difficulty_tag}} />
          { this.state.draggable && (
              <div className="handle">
                <i className="fa fa-bars" />
                Drag to reorder
              </div>
          )}
          { !this.props.shared && <RemoveLessonForm id={props.id}
              planId={props.planId} onRemove={props.onRemove} /> }
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
        <input name="lesson_plan[planned_lessons_attributes][0][_destroy]"
          type="hidden" value="true" />
        <input name="lesson_plan[planned_lessons_attributes][0][id]"
          type="hidden" value={this.props.id} />
        <input type="submit" className="remove-lesson" value="Remove this lesson" />
      </form>
    );
  }
})
