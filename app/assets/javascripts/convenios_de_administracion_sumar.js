$(document).ready(function(){
 $('#convenio_de_administracion_sumar_firmante_id').chained('#convenio_de_administracion_sumar_administrador_id');

 //Actualiza el chosen del metodo de validacion.
 $('#convenio_de_administracion_sumar_administrador_id').change(function(){
 	$("#convenio_de_administracion_sumar_firmante_id").trigger("chosen:updated");
 });

 $('#convenio_de_administracion_sumar_administrador_id').trigger("change");

});
