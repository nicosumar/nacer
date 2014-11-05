$(document).ready(function(){
  $('select#sucursal_bancaria_provincia_id').chained('select#sucursal_bancaria_pais_id');
  $('select#sucursal_bancaria_departamento_id').chained('select#sucursal_bancaria_provincia_id');
  $('select#sucursal_bancaria_distrito_id').chained('select#sucursal_bancaria_departamento_id');

  $('select#sucursal_bancaria_pais_id').trigger("change");
});