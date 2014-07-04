$(document).ready(function(){
  $("#documento_generable_por_concepto_genera_numeracion").attr('checked', false);

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

  $("#documento_generable_por_concepto_genera_numeracion").on("click", function(e){
    //Si checkea comunitaria, desactivo la busqueda de afiliados
    $("#documento_generable_por_concepto_funcion_de_numeracion").prop('disabled',$(this).is(':checked') == "1" ? false : true);
    $("#documento_generable_por_concepto_funcion_de_numeracion").val('');
  });


});