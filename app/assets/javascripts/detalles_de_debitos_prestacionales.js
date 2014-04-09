$(document).ready(function(){
  //inicializo los combos desactivados
  $("#es_comunitaria").attr('checked', false);
  $("#detalle_de_debito_prestacional_motivo_de_rechazo").select2('enable', false);

  $("#detalle_de_debito_prestacional_afiliado_id").on("select2-loaded", function(e){
    $(function() {
      $( document ).tooltip({
        track: true,
        items: "[data-tooltip]",
        content: function() {
          var element = $( this );
          if ( element.is( "[data-tooltip]" ) ) {
            var text = element.text();
            return element.data('tooltip');
          }
        }
      });
    });
  });
    
  $("#es_comunitaria").on("click", function(e){
    //Si checkea comunitaria, desactivo la busqueda de afiliados
    $("#detalle_de_debito_prestacional_afiliado_id").select2('enable', $(this).is(':checked') == "1" ? false : true);
    //y activo la busqueda de prestaciones sin afiliado
    $("#detalle_de_debito_prestacional_prestacion_liquidada_id").select2('enable', $(this).is(':checked') == "1" ? true : false)  

  });

  //On change select prestaciones liquidadas
  $("#detalle_de_debito_prestacional_prestacion_liquidada_id").on("change", function(e){
    prestacion = $("#detalle_de_debito_prestacional_prestacion_liquidada_id");

    if(prestacion.select2('val') == "")
    {
      $("#detalle_de_debito_prestacional_motivo_de_rechazo").select2('enable', false);
      $("#detalle_de_debito_prestacional_motivo_de_rechazo").select2('val',"");
    }
    else
      $("#detalle_de_debito_prestacional_motivo_de_rechazo").select2('enable', true);
  });
});

function maquetaPrestaciones(prestacion) {
    var markup = "<table width='100%'><tr>";
    markup += "<td>Cod: <b>"+prestacion.codigo+"</b></td>"+"<td align='right'>Fecha:<b> "+prestacion.fecha+"</b></td>";
    markup += "</tr>";
    markup += "<tr>";
    markup += "<td>Desc:<b>"+prestacion.nombre+"</b></td><td align='right'>Monto<b> $"+prestacion.monto+"</b></td>";
    markup += "</tr>";
    markup += "</table>";

    return markup;
}
function seleccionaPrestacion(prestacion) {
    return "Cod:<b> "+prestacion.codigo+"</b> - Fecha:<b> "+prestacion.fecha+"</b>"+" - Monto:<b> $"+prestacion.monto+"</b>";
}

function maquetaAfiliado(afiliado) {
    var markup = "";
    var tooltip = "";
    var algunDato = false;

    var tooltip = "<table><tr>";
    if(afiliado.documento_madre !== null )
    {
      tooltip += "<tr>";
      tooltip += "<td>Madre:<b>"+afiliado.nombre_madre+"</b>(<b>"+afiliado.documento_madre+"</b>)</td>";
      tooltip += "</tr>";
      algunDato = true;
    }
    if(afiliado.documento_padre != null)
    {
      tooltip += "<tr>";
      tooltip += "<td>Padre:<b>"+afiliado.nombre_padre+"</b>(<b>"+afiliado.documento_padre+"</b>)</td>";
      tooltip += "</tr>";
      algunDato = true;
    }
    if(afiliado.documento_tutor != null)
    {
      tooltip += "<tr>";
      tooltip += "<td>Tutor:<b>"+afiliado.nombre_tutor+"</b>(<b>"+afiliado.documento_tutor+"</b>)</td>";
      tooltip += "</tr>";
      algunDato = true;
    }
    tooltip += "</table>";


    if(!algunDato)
      tooltip = "No hay datos adicionales sobre el afiliado";

    //Creo el layout del afiliado con el tooltip para cada elemento
    markup += "<table width='100%' ><tr>";
    markup += "<td><b>"+afiliado.nombre+"</b>(<b>"+afiliado.documento+"</b>)</td>";
    markup += "<td align='right'>Fecha Nac.:<b> "+afiliado.fecha_de_nacimiento+"</b>("+afiliado.edad+")</td>";
    //markup += "<td><img width='32' height='32' src='/assets/info.png' style= 'max-width: 100%; width: 100%; height: auto;' data-tooltip='"+tooltip+"'></td>";
    markup += "<td align='right'><img width='20' height='20' src='/assets/info.png' data-tooltip='"+tooltip+"'></td>";
    markup += "</tr>";
    markup += "</table>";

    return markup;
}
function seleccionaAfiliado(afiliado) {
    return "<b>"+afiliado.nombre+"</b> ("+afiliado.documento+")";
}