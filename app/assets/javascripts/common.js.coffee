$(document).on 'turbolinks:load', (e) ->
  # To set height of event list
  if $('.event-list').length > 0
    setEventListHeight()
    $(window).resize () ->
      setEventListHeight()

setEventListHeight = ->
  panel = $('.event-list')
  panel.height(window.innerHeight - panel.offset().top)
