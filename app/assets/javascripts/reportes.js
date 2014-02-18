$(document).ready(function(){

	$( "#dialog-form" ).dialog({
      autoOpen: false,
      height: 300,
      width: 500,
      modal: true,
      buttons: {
        "Buscar": function() {
            $('#formulario_filtro').submit();
            $( this ).dialog( "close" );
        },
        "CSV": function() {
            // cambio el action del form para poder devolver el CSV
            var accion = $('#formulario_filtro').get(0).action;
            $('#formulario_filtro').get(0).setAttribute('action', $('#formulario_filtro').get(0).action + ".csv");
            $('#formulario_filtro').submit();
            $( this ).dialog( "close" );
            $('#formulario_filtro').get(0).setAttribute('action', accion);
        },
        Cancelar: function() {
          $( this ).dialog( "close" );
        }
      },
      close: function() {
      	//Limpiar los elementos del form
        $("#filtros").empty();
      }
    });

    //agarro los clicks de los links con class = reportlink (los reportes)
	$('a.reportlink').bind('click', function(){
		//me traigo la info de ese reporte
		f = $(this).data('repor');
		
      	//Borro los filtors anteriores
        $("#filtros").empty();
        //Agrego un puntero al registro que selecciono
        $( "#filtros" ).append('<input type="hidden" id="reporte_id" name="reporte[id]" value="'+f.id+'">');
        //Busco los filtros y creo los input y los labels y le pongo valor x defecto
      	$.each(f.informes_filtros, function(indice, ifiltro){
      		$( "#filtros" ).append('<label for="reporte_parametros'+ifiltro.posicion+'">'+ifiltro.nombre+'</label>  ');
      		$( "#filtros" ).append('<input id="reporte_parametros_'+ifiltro.posicion+'" name="reporte[parametros]['+ifiltro.posicion+']" value="'+ifiltro.valor_por_defecto+'" type="text" readonly><br>');
      	//Verifico si agregaron validadores para los inputs
          switch (ifiltro.informe_filtro_validador_ui.tipo){
            case "datepicker":
              $("input#reporte_parametros_"+ifiltro.posicion).datepicker({  dateFormat: "yy-mm-dd",
                                                                            showOn: "button",      
                                                                            buttonImage: "/assets/calendar.gif",
                                                                            buttonImageOnly: true });  
            break;
            case "texto":
              $("input#reporte_parametros_"+ifiltro.posicion).autoGrowInput({
                                                                              comfortZone: 50,
                                                                              minWidth: 200,
                                                                              maxWidth: 500
                                                                          });
              $("input#reporte_parametros_"+ifiltro.posicion).attr("readonly", false);
            break;
            case "spinner":
              $("input#reporte_parametros_"+ifiltro.posicion).spinner();
            break;
          }
        });
      	//abro el cuadro de dialogo
      	$( "#dialog-form" ).dialog( "open" );
	});
});

