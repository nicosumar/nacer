$(document).ready(function() {
	$( "#anexo_administrativo_prestacion_estado_de_la_prestacion_id" ).change(function() {
	  $("#spinner").show();
	  $(this).parents("form").submit();
	});
	$( "#anexo_administrativo_prestacion_motivo_de_rechazo_id" ).change(function() {
	  $("#spinner").show();
	  $(this).parents("form").submit();
	});
	$("#spinner").hide();
});
