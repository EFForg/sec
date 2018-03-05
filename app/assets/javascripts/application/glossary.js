$(document).on('mouseover', '.glossary-term', toggleDefinition);
$(document).on('mouseout', '.glossary-term', function(e) {
 $('.glossary-definition').hide('fast');
});

function toggleDefinition(e) {
  e.preventDefault();

  id = $(e.target).data()['toggle']
  $("#"+id).toggle('fast');
};
