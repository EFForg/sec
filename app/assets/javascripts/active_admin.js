//= require active_admin/base
//= require ckeditor/init
//= active_material
//= require select2
//= require jquery_ujs

$(window).on("load", function() {
  $("select.select2").select2();

  $("input[type='file']").on("change", function(event) {
    var field = $(this);
    var files = event.target.files;
    var image = files[0]
    var reader = new FileReader();
    reader.onload = function(file) {
      preview_file(file, field);
    }
    reader.readAsDataURL(image);
  });
});

preview_file = function(file, field) {
  if (file_type(file.target.result) == "image") {
    var preview = new Image();
    preview.src = file.target.result;
  } else {
    var preview = "Upload preview is not supported for this file type.";
  }
  field.parent().find(".inline-hints").html(preview);
}

file_type = function(result) {
  return result.split(",")[0].split(":")[1].split(";")[0].split("/")[0];
}
