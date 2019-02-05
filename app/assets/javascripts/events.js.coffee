$(document).on 'turbolinks:load', (e) ->
  $('#datetimepicker1, #datetimepicker2').datetimepicker({
    format: 'YYYY/MM/DD HH:mm'
  })

  setEventTimezone = () ->
    options = $('#event_time_zone option')
    local_time_zone = Intl.DateTimeFormat().resolvedOptions().timeZone
    time_zone = $('#event_time_zone').data('value') || local_time_zone

    document.getElementById('event_time_zone').value = time_zone

  if ($('#event_time_zone').length)
    $('#event_time_zone').timezones()
    if !($('#event_time_zone').hasClass('assigned'))
      setEventTimezone()

  $('#replace-img-btn').on 'click', (e) ->
    e.preventDefault()

    $('.upload-btn-block').removeClass('hidden')
    $('.uploaded-block').addClass('hidden')
    $('#event_main_picture').val('')

  $('#event_main_picture').on 'change', (e) ->
    $('.upload-btn-block').addClass('hidden')
    $('.uploaded-block').removeClass('hidden')

  $('#event-next-btn').on 'click', (e) ->
    e.preventDefault()

    $('#event-create-btn').removeClass('hidden')
    $(this).addClass('hidden')
