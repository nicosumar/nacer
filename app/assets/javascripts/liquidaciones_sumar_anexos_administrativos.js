$(document).ready(function() {
	// Encadeno los combos
	$("select[id^=anexo_administrativo_prestacion_motivo_de_rechazo_id]").each (function () { 
		var id = this.id;
		var sacar = 'anexo_administrativo_prestacion_motivo_de_rechazo_id_';
		id = id.replace(sacar,'');

		$(this).chained("select[id=anexo_administrativo_prestacion_estado_de_la_prestacion_id_"+id+"]");

		$(this).trigger("change");

	});
	//Init:
	//Oculto el spinner al inicio y disparo el change en los combos de estado para evitar que los muestre mal
	$("#spinner").hide();
	
	// LLamadas ajax para actualizar 
	$( "select[id^=anexo_administrativo_prestacion_motivo_de_rechazo_id]" ).change(function() {
	  $("#spinner").show();
	  $(this).parents("form").submit();
	});
	$( "select[id^=anexo_administrativo_prestacion_estado_de_la_prestacion_id]" ).change(function() {
	  $("#spinner").show();
	  $(this).parents("form").submit();
	});




});
