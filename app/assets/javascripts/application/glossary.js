
(function() {
  function open(term) {
    $('#glossary')
      .html(term.dataset.description)
      .data('term_id', term.dataset.term_id)
      .addClass('open');
  }

  function close() {
    $('#glossary')
      .css('max-height', '')
      .css('transition', '')
      .data('term_id', null)
      .removeClass('open');
  }

  $(document).on('click', '.glossary-term', function(e) {
    if (!e.metaKey && !e.shiftKey && !e.ctrlKey) {
      e.preventDefault();

      if ($('#glossary').data('term_id') == this.dataset.term_id)
        close();
      else
        open(this);
    }
  });

  $(document).on('click', '#glossary .close', close);

  $(document).on('click', function(e) {
    if (!$(e.target).closest('#glossary, .glossary-term').length)
      close();
  });
})();
