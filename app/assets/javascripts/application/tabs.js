$(document).on("turbolinks:load", function() {
  $(".tabs .tab a").click(function() {
    $(".tabs .tab").removeClass( 'active' );
    $( this ).parents(".tab").addClass( 'active' );
  });
});
