$(document).on 'turbolinks:load', (e) ->
  $('#datetimepicker1, #datetimepicker2').datetimepicker({
    format: 'YYYY/MM/DD HH:mm'
  })