
$(document).on("click", ".share-links-sidebar .facebook", function(e) {
  var url = $(this).attr("href");
  window.open(url, "Share on Facebook", "width=650,height=500");
  e.preventDefault();
});

$(document).on("click", ".share-links-sidebar .twitter", function(e) {
  var url = $(this).attr("href");
  window.open(url, "Share on Twitter", "width=550,height=420");
  e.preventDefault();
});
