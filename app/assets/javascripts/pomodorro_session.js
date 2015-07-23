// global settings

var interval = 15000; // miliseconds
var time = 1500; // seconds

// functions

var refresh_loop = function(){
  setInterval(function() {
    params = {'interval': interval};
    update_pomodorro_session(params);
  }, interval);
}

var create_pomodorro_session = function(params) {
  $.ajax('/pomodorro_session', {
      type: 'POST',
      dataType: 'json',
      data: params,
      success: function(response) {
        console.trace("CREATE:");
        console.trace(response);
        hide_pomodorro_flash();
        update_pomodorro_session_info(response, type_create); 
      },
      error: function(response) {
      }
    });
}

var get_pomodorro_session = function() {
  $.ajax('/pomodorro_session', {
      type: 'GET',
      dataType: 'json',
      data: {},
      success: function(response) {
        console.trace("GET: ");
        console.trace(response);
        if (pomodorro_session_exists(response) && !pomodorro_session_ends(response)) {
          update_pomodorro_session_info(response, type_update); 
        }
      },
      error: function(response) {
      }
    });
}

var update_pomodorro_session = function(params) {
  $.ajax('/pomodorro_session', {
      type: 'PATCH',
      dataType: 'json',
      data: params,
      success: function(response) {
        console.trace(response);
        console.trace("UPDATE: ");
        if (pomodorro_session_exists(response)) {
          if (pomodorro_session_ends(response)) { 
            delete_pomodorro_session(response.task_id, true);
          }
          else { 
            update_pomodorro_session_info(response, type_update); 
          }
        }
      },
      error: function(response) {
      }
    });
}

var delete_pomodorro_session = function(task_id, increment_counter) {
  $.ajax('/pomodorro_session', {
      type: 'DELETE',
      dataType: 'json',
      data: {},
      success: function(response) {
        console.trace("DELETE: ");
        console.trace(response);
        hide_pomodorro_info();
        if (increment_counter == true) {
          increment_pomodorro_counter(task_id);
        }
      },
      error: function(response) {
      }
    });
}

var increment_pomodorro_counter = function(task_id) {
  var path = '/tasks/' + task_id + '/completed_pomodorro';
  $.ajax(path, {
      type: 'PATCH',
      dataType: 'json',
      data: {},
      success: function(response) {
        hide_pomodorro_info();
        console.trace(response);
        flash_notice();
      },
      error: function(response) {
      }
    });
}

// helpers

var type_create = 'create';
var type_update = 'update';

var flash_notice = function() {
  setTimeout(function() {
    $('#pomodorro-session-flash').html('Pomodorro session completed, +1!').fadeIn('slow');
  }, 100);
}

var update_pomodorro_session_info = function(response, type) {
  var time_left = Math.ceil(response.time/60);
  $('#pomodorro-session-time').html(time_left + '\'');
  $('#pomodorro-session-task').html(response.task_description);
  if (type == type_create) { 
    $('#pomodorro-session').fadeIn('slow'); 
  }
  else { 
    $('#pomodorro-session').show(); 
  }
}

var hide_pomodorro_info = function() {
  $('#pomodorro-session').fadeOut();
}

var hide_pomodorro_flash = function() {
  $('#pomodorro-session-flash').hide();
}

var pomodorro_session_exists = function(response) {
  if (response != undefined && 'time' in response) { return true; }
  else { return false; }
}

var pomodorro_session_ends = function(response) {
  if (response.time <= 0) { return true; }
  else { return false; }
}

// event listeners

var listener_create_session = function() {

  $('.pomodorro-session-create').on('click', function(event){
    event.preventDefault();
    var task_id = $(this).data('task-id');
    var params = {'task_id': task_id, 'time': time};
    create_pomodorro_session(params);
  });
}

var listener_delete_session = function() {
  $('#pomodorro-session-destroy-btn').on('click', function(event){
    event.preventDefault();
    delete_pomodorro_session("", false);
  });
}

// behaviour

$(document).on('ready page:load', function() {
  listener_create_session();
  listener_delete_session();
});

$(document).on('page:load', function() {
  get_pomodorro_session(); // refresh on page load (turbolinks)
});

$(document).on('ready', function() {
  get_pomodorro_session();
  refresh_loop();
});
