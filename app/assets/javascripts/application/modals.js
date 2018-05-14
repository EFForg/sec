
$(document).on('turbolinks:load', function() {
  if ($('#desktop-canary').is(':visible')) {
    $('.modal').each(function() {
      var reveal = new Foundation.Reveal($(this).addClass('reveal'));
      reveal.open();
    });
  }
});

$(document).on('ajax:before', '.modal form.dismiss', function(e) {
  var modal = $(this).closest('.modal');

  if (modal.is('.reveal'))
    modal.foundation('close');
  else
    modal.remove();

  return $(this).find('input[name=dismiss]').is(':checked');
});

