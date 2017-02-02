$(document).ready(function() { 
  $('[data-remote]').click(function(event){  
    event.preventDefault();

    $('#blockUI_div_spinner').show();
    $('#blockUI_div_aceptar').hide();
    $('#blockUI_div_titulo').empty().append('Procesando');
    $('#blockUI_div_mensaje').empty().append('Por favor, espere...');
    $('#blockUI_div').removeClass();

    $.blockUI({ message: $('#blockUI_div') });

  })

  .bind('ajax:success', function(evt, data, status, xhr){

      $('#blockUI_div_spinner').hide();
      $('#blockUI_div_aceptar').show();
      $('#blockUI_div_titulo').empty().append(data.titulo);
      $('#blockUI_div_mensaje').empty().append(data.mensaje);

      if (data.tipo == 'ok') {
        $('#blockUI_div').removeClass().addClass( 'infobox-ajax-ok' ); 
      } else if (resp_json.tipo == 'advertencia'){
        $('#blockUI_div').removeClass().addClass( 'infobox-ajax-advertencia' );
      }
    })
  
  .bind("ajax:error", function(evt, xhr, status, error){
    
    
    var elemento = $(this),
          errores,
          errorTexto;
    $('#blockUI_div_spinner').hide();
    $('#blockUI_div_aceptar').show();
    $('#blockUI_div').removeClass().addClass( 'infobox-ajax-error' );
      
    try {
    // busco los errores
      errores = $.parseJSON(xhr.responseText);
    } catch(err) {
      // Si la respuesta no es un json valido(como la  exception 500), le pongo un error generico
      errores = {message: "Por favor, recargue la pagina e intente de nuevo"};
    }

    if(typeof errores.titulo == "undefined"){
      $('#blockUI_div_titulo').empty().append(errores.error);
    } else {
      $('#blockUI_div_titulo').empty().append(errores.titulo);
    }

    errorTexto = "<ul>";

    if(errores.mensaje instanceof Array) {
      for ( e in errores.mensaje ) {
        errorTexto += "<li>"  + errores[e] + "</li> ";
      }
    } else {
      if(typeof errores.mensaje != "undefined"  ){
        errorTexto += "<li>"  + errores.mensaje + "</li> ";  
      } 
    }

    errorTexto += "</ul>";

    $('#blockUI_div_mensaje').html(errorTexto);
    });

  $('#blockUI_div_aceptar').click(function() { 
      $.unblockUI(); 
      return false; 
  });
}); 

