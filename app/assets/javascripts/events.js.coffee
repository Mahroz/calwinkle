$(document).on 'turbolinks:load', (e) ->
  $('#datetimepicker1, #datetimepicker2').datetimepicker({
    format: 'YYYY/MM/DD HH:mm'
  })


  setEventTimezone = () ->
    options = $('#event_time_zone option')
    local_time_zone = Intl.DateTimeFormat().resolvedOptions().timeZone
    time_zone = $('#event_time_zone').data('value') || local_time_zone

    for option in options
      if (option.value == time_zone)
        document.getElementById('event_time_zone').value = option.value
        break

  if ($('#event_time_zone').length)
    $('#event_time_zone').timezones()
    if !($('#event_time_zone').hasClass('assigned'))
      setEventTimezone()