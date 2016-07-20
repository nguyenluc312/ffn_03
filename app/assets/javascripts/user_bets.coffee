$(document).on 'click', '#bet-match', (event) ->
  $('#user-bet').removeClass('hidden')
  $(@).hide()
  $('.make-bet-success').html('')
