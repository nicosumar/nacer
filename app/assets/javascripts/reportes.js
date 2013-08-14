

$(document).ready(function(){

	$( "#dialog-form" ).dialog({
      autoOpen: false,
      height: 300,
      width: 500,
      modal: true,
      buttons: {
        "Buscar": function() {
        	//poner el codigo para realizar la busqueda (que mande los parametros y ponga el resultado)
            $( this ).dialog( "close" );
        },
        Cancelar: function() {
          $( this ).dialog( "close" );
        }
      },
      close: function() {
      	//Limpiar los elementos del form
        //allFields.val( "" ).removeClass( "ui-state-error" );
      }
    });

    //agarro los clicks de los links con class = reportlink (los reportes)
	$('a.reportlink').bind('click', function(){
		//me traigo la info de ese reporte
		f = $(this).data('repor');
		
      	//Borro los filtors anteriores
        $("#filtros").empty();
        //Busco los filtros y creo los input y los labels y le pongo valor x defecto
      	$.each(f.informes_filtros, function(indice, ifiltro){
      		$( "#filtros" ).append('<label for="reporte_'+ifiltro.posicion+'">'+ifiltro.nombre+'</label>');
      		$( "#filtros" ).append('<input id="reporte_'+ifiltro.posicion+'" name="reporte['+ifiltro.posicion+']" value="'+ifiltro.valor_por_defecto+'" type="text" ><br>');
          $($("input#reporte_"+ifiltro.posicion)).autoGrowInput({
              comfortZone: 50,
              minWidth: 200,
              maxWidth: 2000
          });
      	});
      	//Verifico si agregaron validadores para los inputs
      	/*$.each(f.validadores,function(fil, tip){ 
      		if(tip =="datepicker"){
      			$( "#reporte_"+fil ).datepicker({ altFormat: "yyyy-mm-dd" });	
       		}
      	});*/
      	//abro el cuadro de dialogo
      	$( "#dialog-form" ).dialog( "open" );
	});
 
	//$("#desde").datepicker({ altFormat: "yyyy-mm-dd" }); //.css("border","3px solid red");
	alert("hola");
});

