
$(document).on('click', '.expand-collapsed', function(e) {
  e.preventDefault();

  $('.collapse').addClass('uncollapse');
  if (window.history && history.replaceState) {
    var url = window.location.href;
    if (url.indexOf('expand') == -1) {
      if (window.location.search.length)
        url += '&expand=1';
      else
        url += '?expand=1';

      history.replaceState({}, '', url);
    }
  }
});
