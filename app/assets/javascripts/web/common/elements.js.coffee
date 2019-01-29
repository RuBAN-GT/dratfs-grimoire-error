$(document).on 'turbolinks:load', ->
  $('.ui.dropdown').dropdown()

  $('.flash .message .close').click ->
    $(this).parents('.message').fadeOut 400, ->
      $(this).remove()
