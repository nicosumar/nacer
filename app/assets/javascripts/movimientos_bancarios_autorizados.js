$(document).ready(function(){
  
  //Creo el modal
  $(function() {
    $( "#errores" ).dialog({
      modal: true,
      autoOpen: false,
      width: 810,
      height: 250,
      buttons: {
        Cerrar: function() {
          $( this ).dialog( "close" );
        }
      }
    });
  });

  $('select#movimiento_bancario_autorizado_cuenta_bancaria_origen_id').chained('select#organismo_gubernamental');
  $('select#movimiento_bancario_autorizado_cuenta_bancaria_destino_id').chained('select#efector');
  $('select#organismo_gubernamental').trigger("change");
  $('select#efector').trigger("change");


});