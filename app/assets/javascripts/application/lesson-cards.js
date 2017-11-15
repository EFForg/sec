$(document).on('turbolinks:load', function(){
  if ($('body').hasClass('section-home')) {
      function cardResize() {
        var cardWidth= $('div.topic.card').width();
        $('div.topic.card').css("height", cardWidth);
      }
      cardResize();
      $( window ).resize(function() {
        cardResize();
      });
  }
});
