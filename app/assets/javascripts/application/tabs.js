$(document).on("turbolinks:load", function() {
  $(".tab a").click(function() {
    $(".tab").removeClass( 'active' );
    $( this ).parents(".tab").addClass( 'active' );
  });
});
