
$(document).on('click', '.expand-collapsed', function(e) {
  e.preventDefault();

  $('.collapse').addClass('uncollapse');
  $('.expand-collapsed').hide();
  if (window.history && history.replaceState && this.href) {
    history.replaceState({}, '', this.href);
  }
});

$(document).on('turbolinks:load ajax:complete', function(e) {
  if (!window.session)
    return;

  var lessonPlanLessons = window.session.lessonPlanLessons;

  $('#lesson-count, .lesson-count')
    .html('(' + lessonPlanLessons.length + ')');

  $('form.add_remove_lesson').each(function() {
    if (lessonPlanLessons.indexOf($(this).data('lesson-id')) != -1)
      $('input[name=_method]', this).attr('value', 'delete');
    else
      $('input[name=_method]', this).attr('value', 'post');
  });
});
