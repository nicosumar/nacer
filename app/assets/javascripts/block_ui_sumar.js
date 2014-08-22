$(document).ready(function() { 
  $('[data-remote]').click(function(event){  
    //event.preventDefault();

    $('#blockUI_div_spinner').show();
    $('#blockUI_div_aceptar').hide();
    $('#blockUI_div_titulo').empty().append('Procesando');
    $('#blockUI_div_mensaje').empty().append('Por favor, espere...');
    $('#blockUI_div').removeClass();
            
    $.blockUI({ message: $('#blockUI_div') });

/*            $.ajax({
              type: 'post',
              url: url,
              data: data,
              dataType: 'json',
              success: function(resp_json){
                
                $('#blockUI_div_spinner').toggle();
                $('#blockUI_div_aceptar').toggle();
                $('#blockUI_div_titulo').empty().append(resp_json.titulo);
                $('#blockUI_div_mensaje').empty().append(resp_json.mensaje);

                if (resp_json.tipo == 'ok') {
                  $('#blockUI_div').removeClass().addClass( 'infobox-ajax-ok' );
                } else if (resp_json.tipo == 'error'){
                  $('#blockUI_div').removeClass().addClass( 'infobox-ajax-error' );
                } else if (resp_json.tipo == 'advertencia'){
                  $('#blockUI_div').removeClass().addClass( 'infobox-ajax-advertencia' );
                }
              }
            });*/
  });
/*
.bind('ajax:success', function(evt, data, status, xhr){
    if (resp_json.tipo == 'ok') {
      $('#blockUI_div').removeClass().addClass( 'infobox-ajax-ok' );
    } else if (resp_json.tipo == 'error'){
      $('#blockUI_div').removeClass().addClass( 'infobox-ajax-error' );
    } else if (resp_json.tipo == 'advertencia'){
      $('#blockUI_div').removeClass().addClass( 'infobox-ajax-advertencia' );
    }
  });*/
}); 

$('#blockUI_div_aceptar').click(function() { 
      $.unblockUI(); 
      //return false; 
  });