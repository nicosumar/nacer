$(document).ready(function(){
  //inicializo los combos desactivados
  $("#detalle_de_debito_prestacional_motivo_de_rechazo").select2('enable', false)

  $("#detalle_de_debito_prestacional_prestacion_liquidada_id").change(function(){
    prestacion = $("#detalle_de_debito_prestacional_prestacion_liquidada_id");

    if(prestacion.select2('val') == "")
      $("#detalle_de_debito_prestacional_motivo_de_rechazo").select2('enable', false)
    else
      $("#detalle_de_debito_prestacional_motivo_de_rechazo").select2('enable', true)

    
      
  });

});