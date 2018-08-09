
(function() {
  function open(term) {
    $('#glossary')
      .html(term.dataset.description)
      .data('term_id', term.dataset.term_id)
      .addClass('open')
      .focus();
  }

  function close() {
    $('#glossary')
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

  $(document).on('click', '#glossary .close', function() {
    var tid = $('#glossary').data('term_id');
    $('.glossary-term[data-term_id=' + tid + ']').focus();
    close();
  });

  $(document).on('click', function(e) {
    if (!$(e.target).closest('#glossary, .glossary-term').length)
      close();
  });

  $(document).on('keydown', function(e) {
    if (e.which == 27) {
      var tid = $('#glossary').data('term_id');
      $('.glossary-term[data-term_id=' + tid + ']').focus();
      close();
    }
  });
})();
