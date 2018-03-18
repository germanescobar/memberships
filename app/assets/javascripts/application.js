// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require turbolinks
//= require jquery
//= require popper
//= require bootstrap-sprockets
//= require_tree .

var cleanField = function(field) {
  $(field)
    .removeClass('is-invalid')
    .siblings('.invalid-feedback').remove();
}

var invalidField = function(field, message) {
  $(field)
    .addClass('is-invalid')
    .after('<div class="invalid-feedback">' + message + '</div>');
}

var growl = function(type, message) {
  $('<div class="alert alert-dismissible alert-' + type + ' alert-growl"><button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>' + message + '</div>')
      .appendTo('body')
      .delay(4000)
      .fadeOut(4000, function() {
        $(this).remove()
      });
}
