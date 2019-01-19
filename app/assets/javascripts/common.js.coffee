$(document).on 'ready page:load', (e) ->
  $('.alert-container .alert').delay(500).fadeIn 'normal', ->
    $(this).delay(2500).fadeOut()
  if $('.event-list').length > 0
    setEventListHeight()
    $(window).resize () ->
      setEventListHeight()

setEventListHeight = ->
  panel = $('.event-list')
  panel.height(window.innerHeight - panel.offset().top)
