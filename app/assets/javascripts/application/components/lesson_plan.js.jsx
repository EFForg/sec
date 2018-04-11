//= require jquery-ui-sortable-npm

var LessonPlan = createReactClass({
  getInitialState: function() {
    return {
      lessons_count: this.props.lessons_count,
      duration_in_words: this.props.duration_in_words,
      lessons: this.props.lessons
    };
  },

  componentDidMount: function() {
    var self = this;

    $(this.refs.lessons).sortable({
      axis: "y",
      stop: self.reorderLessons
    });
  },

  reorderLessons: function(e) {
    console.log("Pending functionality");
  },

  removeLesson: function(lesson) {
    var self = this;

    $.ajax({
      type: "DELETE",
      url: `/lesson-plans/${self.props.id}/lessons`,
      data: {
        lesson_id: lesson.id
      }
    }).success((res) => {
      self.setState({
        lessons_count: res.lessons_count,
        duration_in_words: res.duration_in_words,
        lessons: res.lessons
      });
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
        <ul className="lessons" ref="lessons">
          {state.lessons.map((lesson) =>
            <Lesson {...lesson}
                    key={lesson.id}
                    removeLesson={(e) => this.removeLesson(lesson)} />
          )}
        </ul>
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

var Lesson = createReactClass({
  render: function() {
    var props = this.props;

    return (
      <li className="lesson card">
        <div className="top">
          <div className="icon" dangerouslySetInnerHTML={{__html: props.rendered_icon}} />
          <h3>{props.name}</h3>
          <div className="duration">Duration: {props.duration}</div>
          <div className="levels" dangerouslySetInnerHTML={{__html: props.difficulty_tag}} />
          <button className="remove-lesson" onClick={props.removeLesson}>
            Remove this lesson
          </button>
        </div>
      </li>
    );
  }
});
