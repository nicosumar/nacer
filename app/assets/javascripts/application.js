// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require cocoon
//= require select2
//= require jquery.ui.datepicker
//= require jquery.ui.spinner
//= require jquery.ui.dialog
//= require jquery.ui.tabs
//= require chosen-jquery
//= require wice_grid 

$(document).ready(function() {
  $('.multi_select').chosen({no_results_text: "Ningún resultado concuerda con", allow_single_deselect: true, disable_search_threshold: 10});
});

$(document).ready(function() {
  $('.select2').each(function(i, e){
    var select = $(e);
    options = {
      placeholder: select.data('placeholder'),
      minimumInputLength: select.data('caracteresminimos')
    };
    ;
    if (select.hasClass('ajax')) {
      options.ajax = {
        url: select.data('source'),
        dataType: 'json',
        quietMillis: 750,
        data: function(term, page) { return { q: term, page: page, per: 10 } },
        results: function(data, page) { return { results: eval("data." + select.data('coleccion'))} }
      }
      options.dropdownCssClass = "bigdrop";
    }
    select.select2(options);
  })    
});

//Usar la clase "jquery_fecha" para cambiar un input text a jquery con calendar
$(document).ready(function() {
  $('.jquery_fecha').datepicker({  dateFormat: "yy-mm-dd", showOn: "button", buttonImage: "/assets/calendar.gif", buttonImageOnly: true });  
});

jQuery(function($){
        $.datepicker.regional['es'] = {
                closeText: 'Cerrar',
                prevText: '&#x3c;Ant',
                nextText: 'Sig&#x3e;',
                currentText: 'Hoy',
                monthNames: ['Enero','Febrero','Marzo','Abril','Mayo','Junio',
                'Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre'],
                monthNamesShort: ['Ene','Feb','Mar','Abr','May','Jun',
                'Jul','Ago','Sep','Oct','Nov','Dic'],
                dayNames: ['Domingo','Lunes','Martes','Mi&eacute;rcoles','Jueves','Viernes','S&aacute;bado'],
                dayNamesShort: ['Dom','Lun','Mar','Mi&eacute;','Juv','Vie','S&aacute;b'],
                dayNamesMin: ['Do','Lu','Ma','Mi','Ju','Vi','S&aacute;'],
                weekHeader: 'Sm',
                dateFormat: 'yy-mm-dd',
                firstDay: 1,
                isRTL: false,
                showMonthAfterYear: false,
                yearSuffix: ''};
        $.datepicker.setDefaults($.datepicker.regional['es']);
});
