//= require react
//= require react_ujs

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
