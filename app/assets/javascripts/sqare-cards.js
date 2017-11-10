$(document).ready(function(){

  if ($('body').hasClass('section-home')) {
    var cardSquare = $('div.topic.card');
  } else if ($('body').hasClass('section-materials')) {
    var cardSquare = $('div.materials.card');
  }
      function cardResize() {
        var cardWidth= $cardSquare.width();
        $cardSquare.css("height", cardWidth);
      }
      cardResize();
      $( window ).resize(function() {
        cardResize();
      });

});
