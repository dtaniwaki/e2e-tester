$(function() {
  $(document).on('click', '[data-sidebar-control]', function(e) {
    e.preventDefault()
    let $elem = $(this)
    $('#wrapper_status').toggleClass($elem.data('sidebar-control'))
    $('[data-sidebar-control]').not($elem).each(function(idx) {
      let $other = $(this)
      $('#wrapper_status').removeClass($other.data('sidebar-control'))
    })
  })
})
