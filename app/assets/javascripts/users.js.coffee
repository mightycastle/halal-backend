# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/



jQuery ->
  $('.btn-change-avatar').live 'click', (e) ->
    e.preventDefault()
    $('#user_avatar').click()

  $('#user_avatar').live 'change', (e) ->
    e.preventDefault()
    $('#form_update_avatar').submit()
