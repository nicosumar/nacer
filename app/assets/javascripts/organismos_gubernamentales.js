$(document).ready(function(){
 $('select#organismo_gubernamental_departamento_id').chained('select#organismo_gubernamental_provincia_id');
 $('select#organismo_gubernamental_distrito_id').chained('select#organismo_gubernamental_departamento_id');
 
 $('select#organismo_gubernamental_provincia_id').trigger("change");
});