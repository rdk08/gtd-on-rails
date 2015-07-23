# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $ ->
    $('#task-date-hour').datetimepicker format: 'HH:mm'
    return
  $ ->
    $('#task-date').datetimepicker
      viewMode: 'days'
      format: 'YYYY-MM-DD'
    return

$(document).ready(ready)
$(document).on('page:load', ready)
