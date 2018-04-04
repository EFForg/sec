//= require jquery-ui-sortable-npm

$(window).on("load", function() {
  var lessons = $("#lesson-plan-lessons");
  lessons.sortable({
    // handle: ".handle",
    axis: "y",
    // stop: updatePositions
  });

  // function updatePositions() {
  //   lessons.each(function(i) {
  //     $(this).find("input[name*=position]").val(i);
  //   });
  // }
});

var LessonPlan = createReactClass({
  getInitialState: function() {
    return {
      lessonsCount: this.props.lessons_count,
      durationInWords: this.props.duration_in_words,
      lessons: this.props.lessons
    };
  },

  componentDidMount: function() {

  },

  componentWillUnmount: function() {

  },

  onRemoveLesson: function(e) {
    var state = this.state;
    this.setState({
      lessonsCount: state.lessonsCount - 1,
      lessons: state.lessons.filter(el => el.id.toString() !== e.target.id)
    });
  },

  render: function() {
    var props = this.props;
    var state = this.state;

    return (
      <div className="lesson-plan">
        <div className="your-lessons">
          Your lessons (<span id="lesson-count">{state.lessonsCount}</span>)
        </div>
        <div className="total-duration">
          Total duration: {props.duration_in_words}
        </div>
        <ul id="lesson-plan-lessons">
          {state.lessons.map((lesson) =>
            <Lesson key={lesson.id}
                    id={lesson.id}
                    name={lesson.name}
                    duration={lesson.duration}
                    difficultyTag={lesson.difficulty_tag}
                    renderedIcon={lesson.rendered_icon}
                    onRemoveLesson={this.onRemoveLesson} />
          )}
        </ul>
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
          <button id={props.id} onClick={this.props.onRemoveLesson}>Remove</button>
        </div>
      </li>
    );
  }
});
