$(document).ready(function() {
  $('#rendiciones_detalles').on('cocoon:after-insert', function(e, insertedItem) {
    $('.jquery_fecha').datepicker({  dateFormat: "yy-mm-dd", showOn: "button", buttonImage: "/assets/calendar.gif", buttonImageOnly: true }); 
  });
});

/*
$(document).on('change', 'input', function() {
  // Does some stuff and logs the event to the console
   $('.jquery_fecha').datepicker({  dateFormat: "yy-mm-dd", showOn: "button", buttonImage: "/assets/calendar.gif", buttonImageOnly: true }); 
   
});

$('#rendiciones_detalles').on('cocoon:before-insert', function(e, insertedItem) {
    $('.jquery_fecha').datepicker({  dateFormat: "yy-mm-dd", showOn: "button", buttonImage: "/assets/calendar.gif", buttonImageOnly: true }); 
  }); 
  */