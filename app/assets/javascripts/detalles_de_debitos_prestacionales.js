$(document).ready(function(){
  //inicializo los combos desactivados
  $("#detalle_de_debito_prestacional_motivo_de_rechazo").select2('enable', false)

//.on("change", function(e)
  $("#detalle_de_debito_prestacional_prestacion_liquidada_id").on("change", function(e){
    prestacion = $("#detalle_de_debito_prestacional_prestacion_liquidada_id");

    //alert(prestacion.select2('val'));
    if(prestacion.select2('val') == "")
    {
      $("#detalle_de_debito_prestacional_motivo_de_rechazo").select2('enable', false);
      $("#detalle_de_debito_prestacional_motivo_de_rechazo").select2('val',"");
    }
    else
      $("#detalle_de_debito_prestacional_motivo_de_rechazo").select2('enable', true);

    
      
  });

});