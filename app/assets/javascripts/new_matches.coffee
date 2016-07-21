$(document).on 'change', '.status', (event) ->
  option = $('#select-status').val()
  if option != 'not_started_yet' && option != ''
    $('.goals').removeClass('hidden')
  else
    $('.goals').addClass('hidden')
