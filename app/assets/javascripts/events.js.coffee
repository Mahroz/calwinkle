$(document).on 'turbolinks:load', (e) ->
  OCR_DONT_REPEAT = 'Do not repeat'
  OCR_DAILY = 'Daily'
  OCR_WEEKL_DAYS = 'Week Days'
  OCR_WEEKENDS = 'Weekends'
  OCR_MONTHLY = 'Monthly'
  OCR_YEARLY = 'Yearly'
  OCR_CUSTOM = 'Custom Days'

  setEventTimezone = () ->
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
    
  # If user change date after setting occurance
  $('input[name="start_date"], input[name="end_date"]').on 'change', (e) ->
    setOccuranceRule()

  $('.occurance-type').on 'click', (e) ->
    e.preventDefault()

    type = $(this).text()
    $('#dropdownMenuLink').text(type)

    $('#event_occurance_type').val(type)
    setOccuranceRule()

  setOccuranceRule = () ->
    rule = getOccuranceRule($('#event_occurance_type').val())
    $('#event_occurance_rule').val(rule)

  getOccuranceRule = (type) ->
    rule       = ''
    start_date = moment($('input[name="start_date"]').val(), 'DD/MM/YYYY')

    if (type == OCR_DAILY)
      rule = 'FREQ=DAILY;INTERVAL=1'
    else if (type == OCR_WEEKL_DAYS)
      rule = 'FREQ=WEEKLY;BYDAY=MO,TU,WE,TH,FR;INTERVAL=1'
    else if (type == OCR_WEEKENDS)
      rule = 'FREQ=WEEKLY;BYDAY=SU,SA;INTERVAL=1'
    else if (type == OCR_MONTHLY)
      day = start_date.format('DD')
      rule = "FREQ=MONTHLY;BYMONTHDAY=#{day};INTERVAL=1"
    else if (type == OCR_YEARLY)
      day   = start_date.format('DD')
      month = start_date.format('MM')
      rule  = "FREQ=YEARLY;BYMONTH=#{month};BYMONTHDAY=#{day}"
    else if (type == OCR_CUSTOM)
      rule = 'bohot heavy'

    return rule
