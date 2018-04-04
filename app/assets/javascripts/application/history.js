/**
 * Makes rails-ujs play better with the html5 history api
 * We add a query string ("?remote") to prevent the browser from caching the javascript response.
 */

mark_remote = function(url) {
  return url + ".js?remote";
}

unmark_remote = function(url) {
  return url.replace(".js?remote", "");
}

$(document).on("ajax:before", function(e) {
  e.target.href = mark_remote(e.target.href);
});

$(document).on("ajax:success", function(e) {
  if (e.target.dataset.history && history && history.pushState) {
    history.pushState({remote: true}, "", unmark_remote(e.target.href));
  }
});

$(document).on("ajax:complete", function(e) {
  e.target.href = unmark_remote(e.target.href);
});

window.onpopstate = function(event) {
  if (event.state.remote) {
    var target = mark_remote(window.location.pathname);
    $.getScript(target);
  }
}
