$(document).ready(function() {
	$("input[name*='commit']").prop('disabled', true);
	$("input[name*='aprobar']").bind('click',function(){
		$("input[name*='liquidacion_informe[observaciones]']").prop('disabled', false);
		$("input[name*='commit']").prop('disabled', false);
	});
});