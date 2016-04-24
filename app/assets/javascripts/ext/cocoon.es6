$(document).on('cocoon:after-insert', function(e, target) {
  var $target = $(target)
  $('[data-toggle="tooltip"]', $target).tooltip()

  $('[data-toggle="selectpicker"]', $target).each(function(idx){
    let $this = $(this)
    $this.closest('.bootstrap-select').after($this).remove()
    $this.selectpicker({size: $(this).find('option').length, showIcon: false})
  })
})
