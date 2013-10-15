$(document).ready(function() {
	$("input[name*='aprobar']").bind('click',function(){

		$("input[name*='liquidacion_informe[numero_de_expediente]'").prop('disabled', false);
		$("input[name*='liquidacion_informe[observaciones]'").prop('disabled', false);
	});
});