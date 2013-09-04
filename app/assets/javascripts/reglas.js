$(document).ready(function(){
 $('select#regla_prestacion_id').chainedTo('select#regla_nomenclador_id');
 $('select#regla_metodo_de_validacion_id').chainedTo('select#regla_prestacion_id');
 
 //Actualiza el chossen del metodo de validacion.
 $('select#regla_nomenclador_id').change(function(){
 	$("select#regla_prestacion_id").trigger("liszt:updated");
 });
 //Actualiza el chossen del metodo de validacion.
 $('select#regla_prestacion_id').change(function(){
 	$("select#regla_metodo_de_validacion_id").trigger("liszt:updated");
 });
});

