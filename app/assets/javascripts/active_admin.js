//= require active_admin/base
//= require ckeditor/init
//= active_material
//= require select2
//= require react
//= require react_ujs
//= require_tree ./admin/components

$(window).on("load", function() {
  $("select.select2").select2();

  $("fieldset.reorderable").each(function() {
    var list = $(this).children("ol");

    // Append a handle to each child
    // Main input <li> can either have a child input for position
    // or be directly followed be a <li> with one
    list.find("li.input:not(.hidden)")
      .each(function() {
        var pos = $(this).find("input[name*=position]");
        if (!pos.length) {
          pos = $(this).next("[id*=position]").find("input[name*=position]");
          $(this).append(pos);
        }
      })
     .find("label")
     .after($("<span />", { "class": "handle fa fa-arrows" }))

    list.sortable({
      handle: "> label, > .handle",
      stop: function(e, ui) {
        list.find("li.input:not(.hidden)").each(function(i) {
          $(this).find("input[name*=position]").val(i);
        });
      }
    });
  });

  // Confirm form submission with nested delete
  $("#edit_topic").on("submit", function(e) {
    e.preventDefault();
    var tabs = $(".ui-tabs-panel");

    for (var i = 0; i < tabs.length - 1; i++) {
      var level = $(tabs[i]).attr("id");
      var destroy = $("#topic_lessons_attributes_" + i + "__destroy").is(":checked");

      if (destroy == 1) {
        var message = "Are you sure you want to delete the " + level + " lesson?";
        if (!confirm(message)) { return false; }
      }
    }

    this.submit();
  })

  // Show a preview before submitting a file upload field
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


  var formatImageOption = function(data) {
    if (data.element && data.element.value) {
      return $("<span>").append($("<img>", { src: data.element.dataset.url })).append(data.text);
    }
  };

  $(".select2.icon-gallery").select2({
    templateResult: formatImageOption,
    templateSelection: formatImageOption,
  });

  $('#preview').on('click', function() {
    var url = $('form').attr('action').replace('admin/', '')
                       .replace('/update', '');
    for (var instance in CKEDITOR.instances) {
      CKEDITOR.instances[instance].updateElement();
    }
    var original_method = $('input[name="_method"').val();
    $('input[name="_method"').val('post');
    $.ajax({
      method: 'POST',
      url: url + '/preview',
      data: $('form').serialize(),
      dataType: 'html',
      success: function(data) {
        $('input[name="_method"').val(original_method);
        window.open().document.write(data);
      }
    });
  });

  ReactRailsUJS.mountComponents();
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

// Show flash messages after ajax requests.
$(document).ajaxComplete(function(e, request) {
  var message = request.getResponseHeader("X-Message");
  if (message) {
    $("<div>", { class: "flash" }).text(message).appendTo(".flashes");
  }
});
