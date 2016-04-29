$.extend(true, $, {
  app: {
    test_executions_show: function() {
      let doneTestExecutionPath = $('[data-path-done-test-execution-path]').data('path-done-test-execution-path')
      if ($('[data-execution-state]:not(.hidden)').length == 0) {
        let timerId
        timerId = setInterval(function() {
          if (timerId) {
            $.ajax(doneTestExecutionPath, {
              dataType: 'json'
            }).done(function(res, textStatus, jqXHR) {
              let data = res.data
              data.browsers.forEach(function(browser) {
                if (browser.state === 'failed') {
                  $(`[data-target='head'] [data-test-execution-browser-id=${browser.id}] [data-target='test-execution-browser-error']`).removeClass('hidden').attr('title', browser.message).tooltip('fixTitle')
                }
                browser.steps.forEach(function(step) {
                  let $target = $(`[data-test-step-id=${step.test_step_id}] [data-test-execution-browser-id=${browser.id}]`)
                  $target.find(`[data-state="${step.state}"]`).removeClass('hidden')
                  $target.find(`[data-state]:not([data-state="${step.state}"])`).addClass('hidden')
                  if (step.link_url) {
                    let aTag = $target.find('a')
                    aTag.attr('href', step.link_url)
                  }
                  if (step.screenshot) {
                    if (step.state === 'running') {
                      $('.screenshot', $target).html(`<img src="${$.images.loading}" width="100%" />`)
                    } else if (step.state === 'failed') {
                      $('.screenshot', $target).html(`<img src="${$.images.failed}" width="100%" />`)
                    } else if (step.screenshot) {
                      $('.screenshot', $target).html(`<a href="${step.link_url}" target="_blank"><img src="${step.screenshot.image_url}" width="100%" /></a>`)
                    }
                  }
                })
              })
              if (data.state === 'done' || data.state === 'failed') {
                $(`[data-execution-state="${data.state}"]`).removeClass('hidden')
                timerId = null
                clearInterval(timerId)
              }
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

        let clearTimer
        clearTimer = function() {
          clearInterval(timerId)
          $(document).off('turbolinks:before-render', clearTimer);
        }
        $(document).on('turbolinks:before-render', clearTimer);
      }
    }
  }
})
