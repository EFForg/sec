$(document).on('click', '.quick-feedback .tab a', function(e) {
  e.preventDefault();

  $('.quick-feedback').toggleClass('closed');
});

$(document).on('click', function(e) {
  if (!$(e.target).is('.quick-feedback, .quick-feedback *')) {
    $('.quick-feedback').addClass('closed');
  }
});

$(document).on('submit ajax:before', 'form.new_feedback', function(e) {
  $(e.target).append(
    $('<input>').attr({
      type: 'hidden',
      name: 'feedback[mobile]',
      value: $('#desktop-canary').is(':not(:visible)')
    })
  );
});
