$(document).ready(function(){
  $('select#efector_departamento_id').chained('select#efector_provincia_id');
  $('select#efector_distrito_id').chained('select#efector_departamento_id');
  
  $('select#efector_provincia_id').trigger("change");
});