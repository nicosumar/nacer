$(document).ready(function() {
	// LLamadas ajax para actualizar 
	$( "#anexo_administrativo_prestacion_estado_de_la_prestacion_id" ).change(function() {
	  $("#spinner").show();
	  //actualiza el siguiente combo (el del motivo de rechazo)
 	  $("select#anexo_administrativo_prestacion_motivo_de_rechazo_id").trigger("liszt:updated");
	  $(this).parents("form").submit();
	});
	$( "#anexo_administrativo_prestacion_motivo_de_rechazo_id" ).change(function() {
	  $("#spinner").show();
	  $(this).parents("form").submit();
	});

	// Encadeno los combos
	$('select#anexo_administrativo_prestacion_motivo_de_rechazo_id').chained('select#anexo_administrativo_prestacion_estado_de_la_prestacion_id');

	//Init:
	//Oculto el spinner al inicio y disparo el change en los combos de estado para evitar que los muestre mal
	$("#spinner").hide();
	$('select#anexo_administrativo_prestacion_estado_de_la_prestacion_id').trigger("change");


});
