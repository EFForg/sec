$(document).on('mouseover', '.glossary-term, .glossary-definition', (e) => {
  var def = $(e.target).closest('.glossary-term').find('.glossary-definition');
  clearTimeout(def.data('timeout'));
  def.data('timeout', null).show();
});

$(document).on('mouseout', '.glossary-term, .glossary-definition', (e) => {
  var def = $(e.target).closest('.glossary-term').find('.glossary-definition');
  if (!def.data('timeout')) {
    def.data('timeout', setTimeout(() => {
      def.data('timeout', null).hide();
    }, 200));
  }
});

$(document).on('click', '.glossary-term', (e) => {
  window.open($(e.target).find('a').attr('href'));
});
