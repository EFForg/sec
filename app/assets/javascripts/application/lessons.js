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
    const res = JSON.parse(e.detail[2].response);

    $('.lesson-count').html(res.lessons_count);

    const lesson_ids = res.lessons.map(el => el.id);
    $('form.add_remove_lesson').each(function() {
      if (lesson_ids.indexOf($(this).data('lesson-id')) != -1)
        $('input[name=_method]', this).attr('value', 'delete');
      else
        $('input[name=_method]', this).attr('value', 'post');
    });
  }
});
