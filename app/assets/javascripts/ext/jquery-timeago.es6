$.timeago.settings.allowFuture = true
$(document).on('turbolinks:load', function() {
  $('[data-timeago]').timeago()
})
