$(document).on('changed.bs.select', '#browser_sets_select', function(e, idx, newValue, oldValue) {
  var browser_ids = $(`#browser_sets_select option:nth(${idx})`).data('browser-ids')
  var $checkboxes = $('#all_browsers input:checkbox')
  if (browser_ids) {
    $checkboxes.filter(function(idx) { return browser_ids.indexOf($(this).attr('value')) !== -1 }).prop('checked', true)
    $checkboxes.filter(function(idx) { return browser_ids.indexOf($(this).attr('value')) === -1 }).prop('checked', false)
  }
})

$(document).on('click', '#toggle_browsers', function(e){
  e.preventDefault()
  if ($('#all_browsers').is(":visible")) {
    $("#all_browsers").slideUp()
    $('#toggle_browsers').text('Show all browsers')
  } else {
    $("#all_browsers").slideDown()
    $('#toggle_browsers').text('Hide all browsers')
  }
})

$(document).on('click', '[data-unset-all]', function(e){
  e.preventDefault()
  $($(this).data('unset-all')).find('input[type=checkbox]').prop('checked', false)
})

$(document).on('turbolinks:load cocoon:after-insert', function(e, target) {
  $('[data-sortable]').each(function() {
    $(this).sortable({
      handle: '[data-sortable-handle]',
      placeholder: 'e2e-test-step-placeholder',
      items: $(this).data('sortable')
    })
  })
})

$(document).on('turbolinks:load', function(e, target) {
  $('[data-switch-on-click]').each(function(idx) {
    let $this = $(this)
    let $target = $($this.data('switch-on-click'))
    $this.click(function(e) {
      $target.removeClass('hidden').focus()
      $this.addClass('hidden')
    })
  })
})
