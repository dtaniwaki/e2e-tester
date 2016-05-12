$(document).on('turbolinks:load', function() {
  $('[data-datetimepicker]').each(function(idx) {
    $(this).datetimepicker({
      format: 'YYYY/MM/DD hh:mm',
      useCurrent: false,
      minDate: new Date(),
      showClose: true,
      showClear: true,
      showTodayButton: true
    })
  })
})
