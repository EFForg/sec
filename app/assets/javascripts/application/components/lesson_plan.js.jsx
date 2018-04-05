//= require jquery-ui-sortable-npm

var LessonPlan = createReactClass({
  getInitialState: function() {
    return {
      lessonsCount: this.props.lessons_count,
      durationInWords: this.props.duration_in_words,
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

  removeLesson: function(e) {
    var self = this;

    $.ajax({
      type: "DELETE",
      url: `/lesson-plans/${self.props.id}/lessons`,
      data: {
        lesson_id: e.target.id
      }
    }).success((res) => {
      self.setState({
        lessonsCount: res.lessons_count,
        durationInWords: res.duration_in_words,
        lessons: res.lessons
      });
    });
  },

  render: function() {
    var props = this.props;
    var state = this.state;

    const noLessonsMarkup = (
      <div>
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
          Total duration: {state.durationInWords}
        </div>
        <ul id="lesson-plan-lessons" ref="lessons">
          {state.lessons.map((lesson) =>
            <Lesson key={lesson.id}
                    id={lesson.id}
                    name={lesson.name}
                    duration={lesson.duration}
                    difficultyTag={lesson.difficulty_tag}
                    renderedIcon={lesson.rendered_icon}
                    removeLesson={this.removeLesson} />
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
          Your lessons ({state.lessonsCount})
        </div>

        {(state.lessonsCount > 0) ? lessonsMarkup : noLessonsMarkup}
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
          <div className="icon" dangerouslySetInnerHTML={{__html: props.renderedIcon}} />
          <h3>{props.name}</h3>
          <div className="duration">Duration: {props.duration}</div>
          <div className="levels" dangerouslySetInnerHTML={{__html: props.difficultyTag}} />
          <button id={props.id} onClick={props.removeLesson}>Remove</button>
        </div>
      </li>
    );
  }
});
