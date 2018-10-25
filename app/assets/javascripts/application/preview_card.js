$(document).on('ajax:success', 'div.preview-card a.btn', function() {
    var view_url = $(this).attr('href').replace('admin/', '')
                          .replace('?remote', '');
    var view_btn = $("<a>", {"href": view_url, "class": "btn"}).text("View live page");
    alert("Changes submitted.");

    $('div.preview-card a.btn').replaceWith(view_btn);
});
