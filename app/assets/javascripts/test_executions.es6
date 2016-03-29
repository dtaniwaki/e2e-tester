$.extend(true, $, {
  app: {
    test_executions_show: function() {
      let doneTestExecutionPath = $('[data-path-done-test-execution-path]').data('path-done-test-execution-path')
      if ($('.state.initial, .state.running').length > 0) {
        let timerId
        timerId = setInterval(function() {
          if (timerId) {
            $.ajax(doneTestExecutionPath, {
              dataType: 'json'
            }).done(function(data, textStatus, jqXHR) {
              var data = data.data
              if (data.state === 'done') {
                timerId = null
                clearInterval(timerId)
              }
              data.browsers.forEach(function(browser) {
                browser.steps.forEach(function(step) {
                  var $target = $(`#test_step_${step.test_step_id} #test_execution_browser_${browser.id}`)
                  if (step.state === 'running') {
                    $target.addClass('active')
                    if (step.screenshot) {
                      $('.screenshot', $target).html(`<img src="${$.images.loadingGif}" width="100%" />`)
                    }
                  } else if (step.state === 'done' || step.state === 'failed') {
                    $target.removeClass('active')
                    if (step.screenshot) {
                      $('.screenshot', $target).html(`<a href="${step.link_url}" target="_blank"><img src="${step.screenshot.image_url}" width="100%" /></a>`)
                    }
                  }
                  if (step.state !== 'initial') {
                    $('.state', $target).html(`<a href="${step.link_url}" target="_blank">${step.state}</a>`)
                  }
                })
              })
            }).fail(function(jqXHR, textStatus, errorThrown) {
              timerId = null
              clearInterval(timerId)
            })
          }
        }, 500)
        setTimeout(function() {
          if (timerId) {
            timerId = null
            clearInterval(timerId)
          }
        }, 1800000)
      }

    }
  }
})
