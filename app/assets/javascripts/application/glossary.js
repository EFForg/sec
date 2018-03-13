$(document).on('mouseover', '.glossary-term', showDefinition);
$(document).on("click", ".glossary-term", toggleDefinition);
$(document).click(function(e) {
  if (!$(e.target).closest(".glossary-term").length) {
    hideDefinitions();
  };
});

function hideDefinitions() {
  $(".glossary-definition").hide("fast");
}

function toggleDefinition(e) {
  if(e.target == e.currentTarget) {
    $("#"+getDropdownId(e)).toggle("fast");
  }
};

function showDefinition(e) {
  hideDefinitions();
  $("#"+getDropdownId(e)).show("fast");
};

function getDropdownId(e) {
  return $(e.target).data()["toggle"];
}
