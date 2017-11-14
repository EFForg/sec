$(document).ready(function(){
  if (($('body').hasClass('section-lessons')) ||
  ($('body').hasClass('section-topics')))
  {
    $(".tab").click(function() {
      if( !$( this ).hasClass( 'active' ) ) {
        $(".tab").removeClass( 'active' );
        $( this ).addClass( 'active' );
      }

    });
  }
});
