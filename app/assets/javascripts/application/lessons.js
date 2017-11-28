
$(document).on('click', '.expand-collapsed', function(e) {
  e.preventDefault();

  $('.collapse').addClass('uncollapse');
  $('.expand-collapsed').hide();
  if (window.history && history.replaceState && this.href) {
    history.replaceState({}, '', this.href);
  }
});
