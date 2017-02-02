$(document).ready(function(){
 $('#convenio_de_gestion_sumar_firmante_id').chained('#convenio_de_gestion_sumar_efector_id');

 //Actualiza el chosen del metodo de validacion.
 $('#convenio_de_gestion_sumar_efector_id').change(function(){
 	$("#convenio_de_gestion_sumar_firmante_id").trigger("chosen:updated");
 });

 $('#convenio_de_gestion_sumar_efector_id').trigger("change");

});
