$(document).on('click', '.expand-collapsed', function(e) {
  e.preventDefault();

  $('.collapse').addClass('uncollapse');
  $('.expand-collapsed').hide();
  if (window.history && history.replaceState && this.href) {
    history.replaceState({}, '', this.href);
  }
});

document.addEventListener('ajax:success', function(e) {
  if (e.target.className === 'add_remove_lesson') {
    const lesson_ids = JSON.parse(e.detail[2].response);

    $('.lesson-count').html(lesson_ids.length);

    $('form.add_remove_lesson').each(function() {
      if (lesson_ids.indexOf($(this).data('lesson-id')) != -1)
        $('input[name=_method]', this).attr('value', 'delete');
      else
        $('input[name=_method]', this).attr('value', 'post');
    });
  }
});

document.addEventListener('ajax:success', function(e) {
  if (e.target.className === 'add_all_lessons_in_topic') {

    $('form.add_all_lessons_in_topic').each(function() {
      $('input[name=_method]', this).attr('value', 'post');
    });
  }
});
