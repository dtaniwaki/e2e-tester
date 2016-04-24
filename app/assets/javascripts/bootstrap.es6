$(document).on('turbolinks:load', function() {
  $('[data-toggle="selectpicker"]').each(function(idx){
    let $this = $(this)
    $this.closest('.bootstrap-select').after($this).remove()
    $this.selectpicker({size: $(this).find('option').length, showIcon: false})
  })
})
