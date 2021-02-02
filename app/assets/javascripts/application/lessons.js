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

  if (e.target.className === 'add_remove_all_lessons_in_topic') {
    const lesson_ids = JSON.parse(e.detail[2].response)[0];
    const topic_lesson_ids = JSON.parse(e.detail[2].response)[1];

    $('.lesson-count').html(lesson_ids.length);

    if (topic_lesson_ids.every(tli => (lesson_ids.includes(tli))))
      $('input[name=_method]', e.target).attr('value', 'delete');
    else
      $('input[name=_method]', e.target).attr('value', 'post');
  }
});
