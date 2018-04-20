
$(document).on('turbolinks:load', function() {
  if ($('#desktop-canary').is(':visible')) {
    $('.modal').each(function() {
      var reveal = new Foundation.Reveal($(this).addClass('reveal'));
      reveal.open();
    });
  }
});

$(document).on('ajax:before', '.modal form.dismiss', function(e) {
  $(this).closest('.modal').foundation('close');
  return $(this).find('input[name=dismiss]').is(':checked');
});

