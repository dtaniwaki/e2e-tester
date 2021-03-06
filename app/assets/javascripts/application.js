// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui/sortable
//= require turbolinks
//= require bootstrap-sprockets
//= require metisMenu/dist/metisMenu.js
//= require startbootstrap-sb-admin-2/dist/js/sb-admin-2
//= require pwstrength-bootstrap/dist/pwstrength-bootstrap
//= require jquery-timeago/jquery.timeago
//= require zeroclipboard/dist/ZeroClipboard
//= require moment/moment
//= require eonasdan-bootstrap-datetimepicker/build/js/bootstrap-datetimepicker.min
//= require cocoon
//= require ./images
//= require ./global
//= require ./test_executions
//= require_tree ./ext

$(document).on('turbolinks:load', function() {
  var loadFunc = $.app && $.app[$('body').attr('id')]
  if (loadFunc) {
    loadFunc()
  }
})
