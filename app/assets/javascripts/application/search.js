$(document).on('submit', 'header .search form', function(e) {
  if (!$('header').hasClass('search-expanded')) {
    e.preventDefault();
    $('header').addClass('search-expanded');
    $('header .search form input[type=search]').select();
  }
});

$(document).on('click', function(e) {
  if (!$(e.target).is('header .search, header .search *')) {
    $('header').removeClass('search-expanded');
  }
});

