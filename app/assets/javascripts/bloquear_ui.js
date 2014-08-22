$(document).ready(function() { 
  $('#pruebaasdfasdf').click(function() { 
    $.blockUI({ 
      message: $('#spinner'),
      css: { 
        border: 'none', 
        padding: '15px', 
        backgroundColor: '#000', 
        '-webkit-border-radius': '10px', 
        '-moz-border-radius': '10px', 
        opacity: .5, 
        color: '#fff' 
      }
    }); 

    setTimeout($.unblockUI, 10000); 
  }); 
});



$("#prueba").submit(function(event){
  event.preventDefault();

  url = $(this).attr('action');
  data = $(this).data('block-ui');

  $.ajax({
    type: 'put',
    url: url,
    data: data,
    dataType: 'json',
    complete: function(resp_json){
      
      $("#blockUI_titulo").emtpy().append(resp_json.titulo);
      $("#blockUI_mensaje").emtpy().append(resp_json.mensaje);
      if (resp_json.tipo == "ok") {
        $("#blockUI_respuesta").removeClass().addClass( "infobox-ajax-ok" );
      } else if (resp_json.tipo == "error"){
        $("#blockUI_respuesta").removeClass().addClass( "infobox-ajax-error" );
      } else if (resp_json.tipo == "advertencia"){
        $("#blockUI_respuesta").removeClass().addClass( "infobox-ajax-advertencia" );
      }
  
    })
  });
  

});

