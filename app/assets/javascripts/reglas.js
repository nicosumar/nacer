$(document).ready(function(){
 $('select#regla_prestacion_id').chainedTo('select#regla_nomenclador_id');
 $('select#regla_metodo_de_validacion_id').chainedTo('select#regla_prestacion_id');
});

