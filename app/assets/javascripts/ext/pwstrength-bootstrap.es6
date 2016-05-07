$(document).on('turbolinks:load', function() {
  $('[data-password-strength]').each(function(idx) {
    $(this).pwstrength({
      ui: { showVerdictsInsideProgressBar: true },
      minChar: $(this).data('password-strength')
    })
  })
})
