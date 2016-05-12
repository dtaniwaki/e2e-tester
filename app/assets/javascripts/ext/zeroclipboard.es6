$(document).on('turbolinks:load', function() {
  $('[data-zeroclipboard]').each(function(idx) {
    let $button = $(this)
    let id = $button.data('zeroclipboard')
    let client = new ZeroClipboard($button[0])
    client.on('ready', function(readyEvent) {
      $button.click(function(e) {
        e.preventDefault()
        let text = $(id).val()
        client.setData('text/plain', text)
        alert("Copied text to clipboard: " + text)
      })
    })
  })
})
