$(document).on 'ready page:load', (e) ->
  $('.alert-container .alert').delay(500).fadeIn 'normal', ->
    $(this).delay(2500).fadeOut()