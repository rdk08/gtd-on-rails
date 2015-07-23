// global settings

var table = 'table.table.table-striped';
var row_container = 'tbody';
var rows = 'tr';
var table_rows = table + ' ' + row_container + ' ' + rows;

// functions

var search_request = function(target_url, term) {
  $.ajax(target_url, {
    type: 'POST',
    dataType: 'html',
    data: {'term': term},
    success: function(response) {
      update_table_content(response);
    },
    error: function(response) {
    }
  });
}

var update_table_content = function(response) {
  $(table_rows).remove();
  $(table).find(row_container).append(response);
}

// event listeners

var search_field_listener = function() {
  $('#search_field').on('keyup', function(event){
    event.preventDefault();
    var term = $('#search_field').val(); 
    if (term.length == 0 || term.length > 2) {
      search_request('/notes/search', term)
    }
  });
}

// behaviour

$(document).on('ready page:load', function() {
  search_field_listener();
});
