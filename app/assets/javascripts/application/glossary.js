$(document).on('mouseover', '.glossary-term', toggleDefinition);
$(document).on("click", ".glossary-term", toggleDefinition);
$(document).click(function(e) {
  if (!$(e.target).closest(".glossary-term").length) {
    $(".glossary-definition").hide("fast");
  };
});

function toggleDefinition(e) {
  if(e.target == e.currentTarget) {
    id = $(e.target).data()["toggle"];

    $(".glossary-definition").not(e.currentTarget).hide("fast");
    $("#"+id).toggle("fast");
  }
};
