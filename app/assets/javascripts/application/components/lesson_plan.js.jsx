//= require react-sortable-hoc/dist/umd/react-sortable-hoc.js

const {SortableContainer, SortableElement, arrayMove} = window.SortableHOC;

const LessonPlan = createReactClass({
  getInitialState: function() {
    return {
      lessons_count: this.props.lessons_count,
      duration_in_words: this.props.duration_in_words,
      lessons: this.props.lessons
    };
  },

  persistLessonPlan: function(data) {
    self = this;
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
    // Optimistically update during AJAX
    this.setState({
      lessons: arrayMove(this.state.lessons, oldIndex, newIndex)
    });

    this.persistLessonPlan({
      lesson_plan_lessons_attributes: this.state.lessons.map((el, index) => {
        return {
          id: el.id,
          position: index
        }
      })
    });
  },

  removeLesson: function(lesson) {
    this.persistLessonPlan({
      lesson_plan_lessons_attributes: {
        id: lesson.id,
        _destroy: true
      }
    });
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
        <LessonsList lessons={state.lessons}
          onRemove={this.removeLesson}
          onSortEnd={this.reorderLessons} />
      </div>
    );

    return (
      <div className="lesson-plan">
        <div className="export">
          <a href={props.links.download}>Download</a>
        </div>
        <div className="your-lessons">
          Your lessons ({state.lessons_count})
        </div>

        {(state.lessons_count > 0) ? lessonsMarkup : noLessonsMarkup}
      </div>
    );
  }
});

const LessonsList = SortableContainer(({lessons, onRemove}) => {
  return (
    <ul className="lessons">
      {lessons.map((lesson, index) =>
        <Lesson {...lesson}
          key={lesson.id}
          index={index}
          onRemove={(e) => onRemove(lesson)} />
      )}
    </ul>
  );
});

const Lesson = SortableElement((props) => {
  return (
    <li className="lesson card">
      <div className="top">
        <div className="icon" dangerouslySetInnerHTML={{__html: props.rendered_icon}} />
        <h3>{props.name}</h3>
        <div className="duration">Duration: {props.duration}</div>
        <div className="levels"
          dangerouslySetInnerHTML={{__html: props.difficulty_tag}} />
        <button className="remove-lesson" onClick={props.onRemove}>
          <span className="show-for-sr">Remove this lesson</span>
        </button>
      </div>
    </li>
  );
});
