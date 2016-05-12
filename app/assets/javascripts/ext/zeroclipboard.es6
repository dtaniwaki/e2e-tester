ZeroClipboard.config({ swfPath: $.images.zeroclipboard })
$(document).on('turbolinks:load', function() {
  $('[data-zeroclipboard]').each(function(idx) {
    let $button = $(this)
    let client = new ZeroClipboard($button[0])
    client.on('ready', function(readyEvent) {
      client.on('copy', function(event) {
        let text = $($button.data('zeroclipboard')).val()
        event.clipboardData.setData('text/plain', text)
      })
      client.on('aftercopy', function(event) {
        alert('Copied text to clipboard: ' + event.data['text/plain']);
      })
      client.on('error', function(event) {
        console.log( 'ZeroClipboard error of type "' + event.name + '": ' + event.message );
        ZeroClipboard.destroy();
      })
    })
  })
})
