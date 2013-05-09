jQuery ->
  $('.alert, .alert-block').on 'click', '.close', (event) =>
    event.preventDefault()
    $(event.currentTarget).closest('.alert, .alert-block').hide()