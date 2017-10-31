$( function() {
    $(".tab").click(function() {
      if( $( this ).hasClass( 'active' ) ) {
         return;
      }

      $(".tab").removeClass( 'active' );
      $( this ).addClass( 'active' );
  });
});
