
$(document).on('click', '.glossary-term', function(e) {
  if (!e.metaKey && !e.shiftKey && !e.ctrlKey) {
    e.preventDefault();
    $('#glossary')
      .html(this.dataset.description)
      .addClass('open');
  }
});

$(document).on('click', function(e) {
  if (!$(e.target).closest('.glossary-term, #glossary').length) {
    $('#glossary')
      .css('max-height', '')
      .css('transition', '')
      .removeClass('open');
  }
});
