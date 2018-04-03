//= require jquery-ui-sortable-npm

$(window).on("load", function() {
  var lessons = $("#lesson-plan-lessons");
  lessons.sortable({
    // handle: ".handle",
    axis: "y",
    stop: updatePositions
  });

  function updatePositions() {
    lessons.each(function(i) {
      $(this).find("input[name*=position]").val(i);
    });
  }
});

var LessonPlan = createReactClass({
  render: function() {
    var props = this.props;

    console.log(props);

    return (
      <div className="lesson-plan">
        <div className="your-lessons">
          Your lessons (<span id="lesson-count">{props.lessons_count}</span>)
        </div>
        <div className="total-duration">
          Total duration: {props.duration_in_words}
        </div>
        <ul id="lesson-plan-lessons">
          {props.lessons.map((lesson) =>
            <Lesson key={lesson.id}
                    name={lesson.name}
                    duration={lesson.duration}
                    difficultyTag={lesson.difficulty_tag}
                    renderedIcon={lesson.rendered_icon} />
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
        </div>
      </li>
    );
  }
});
