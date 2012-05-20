var editInput;

function showProcessor(element, show) {
  if(editInput == undefined){
    if(show){
      $('#processor_' + element.id).show();
    } else {
      $('.processor_table').hide();
    };
  };
};

function toggleEditProcessor(element){
  if(editInput != undefined){
    setEditState(editInput, false)
    editInput = undefined;
  } else {  
    setEditState(element, true)
    editInput = element;
  };
}

function setEditState(element, edit){
  if(edit){
    $(element).addClass('edited')
    $($('#processor_' + element.id + ' table')[0]).addClass('edited')
  } else {
    $(element).removeClass('edited')
    $($('#processor_' + element.id + ' table')[0]).removeClass('edited')
  }
  $($('#processor_' + element.id +' h4.processor_table_title')).toggle();
  $($('#processor_' + element.id +' h4.edit_processor_table_title')).toggle();
};

function addProcessorRow(element) {
  var row   = $(element).closest('tr').first();
  var clone = $(row).clone();
  var id    = parseInt($(clone.children()[0]).text()) + 1;

  $(clone).attr('id', id);
  $(clone.children()[0]).html(id);
  $(clone.children()[1]).contents().attr('name', 'processor_' + id);
  $(clone.children()[2]).contents().attr('name', 'argument_' + id);
  $(clone.children()[3]).contents().bind('click', function() { addProcessorRow(this) });
  $(row.children()[3]).html('');
  $(clone).insertAfter(row);

};

$(function() {
  $('.addProcessorRow').bind('click', function() { addProcessorRow(this) });
  $('tr.input').bind('mouseenter', function(){showProcessor(this, true)});
  $('tr.input').bind('mouseleave', function(){showProcessor(this, false)});
  $('tr.input').bind('click', function(){toggleEditProcessor(this)});
});