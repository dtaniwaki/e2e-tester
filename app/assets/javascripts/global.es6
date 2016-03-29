$(document).on('changed.bs.select', '#browser_sets_select', function(e, idx, newValue, oldValue) {
  var browser_ids = $(`#browser_sets_select option:nth(${idx})`).data('browser-ids')
  var $checkboxes = $('[data-browser-checkbox]')
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

$(document).on('turbolinks:load', function() {
  $('#browser_sets_select').each(function(idx){
    let $this = $(this)
    $this.closest('.bootstrap-select').after($this).remove()
    $this.selectpicker({size: $(this).find('option').length, showIcon: false})
  })
})

$(document).on('click', '#e2e_variables input[type=checkbox]', function(e) {
  $(this).closest(".e2e-variable").fadeOut()
})

$(document).on('click', '#e2e_add_new_variable', function(e) {
  e.preventDefault()
  e.stopPropagation()
  $(this).closest('tr').before($(this).data("html").replace(/PLACEHOLDER/g, $("#e2e_variables .e2e-variable:visible").length))
})
