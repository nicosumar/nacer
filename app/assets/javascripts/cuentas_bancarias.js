$(document).ready(function(){
 
  $('select#cuenta_bancaria_entidad_id').chained('select#tipo_entidad');
  
  $('select#cuenta_bancaria_sucursal_bancaria_id').chained('select#cuenta_bancaria_banco_id');
 
  $('select#tipo_entidad').trigger("change");
  $('select#cuenta_bancaria_banco_id').trigger("change");

 
});