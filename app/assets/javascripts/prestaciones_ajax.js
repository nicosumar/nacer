var refrescar = true;
$(document).ready(function() {

  $('#prestacion_brindada_prestacion_id').on("select2-removed", function(e) { 
    $('#historia_clinica').empty();
    $('#cantidad_de_unidades').empty();
    $('#diagnostico').empty();
    $('#atributos_reportables').empty();
  })

  $('#prestacion_brindada_prestacion_id').on("change", function (e) {
    prestacion = $("#prestacion_brindada_prestacion_id").select2('data');
    if(prestacion == null )
      return;
    else
      datos_reportables = prestacion.datos_reportables;

    //#diagnostico.field
    div_diag = $('#diagnostico').empty();
    var diag_html = "";
    if(prestacion.diagnosticos.length == 1){
      diag_html += '<input id="prestacion_brindada_diagnostico_id" name="prestacion_brindada[diagnostico_id]" type="hidden" value="'+prestacion.diagnosticos[0].id +'">';
      diag_html += '<div class="field_content">';
      diag_html += '  <span class="field_name">Diagnóstico*</span>';
      diag_html += '  <span class="field_value">'+ prestacion.diagnosticos[0].nombre +'</span>';
      diag_html += '</div>';
      div_diag.append(diag_html);
    }
    else
    {
      diag_html += '<label for="prestacion_brindada_diagnostico_id">Diagnóstico*</label>';
      diag_html += '<select id="prestacion_brindada_diagnostico_id" name="prestacion_brindada[diagnostico_id]"></select>';
      div_diag.append(diag_html);
      for (var j = 0; j < prestacion.diagnosticos.length; j++) {
        $("#prestacion_brindada_diagnostico_id").append($('<option>', { 
              value: prestacion.diagnosticos[j].id,
              text : prestacion.diagnosticos[j].nombre
          }));
      };
      $("#prestacion_brindada_diagnostico_id").chosen({no_results_text: "Ningún resultado concuerda con", allow_single_deselect: true, disable_search_threshold: 10});
    }

    //#historia_clinica.field
    div_hc = $('#historia_clinica').empty();
    if (!prestacion.es_comunitaria) {
      div_hc.append('<label for="prestacion_brindada_historia_clinica">Historia clínica / Nº de informe / Nº de solicitud*</label>');
      div_hc.append('<input id="prestacion_brindada_historia_clinica" name="prestacion_brindada[historia_clinica]" size="15" type="text">');
    };

    //#cantidad_de_unidades.field
    div_cantidad_de_unidades = $('#cantidad_de_unidades').empty();
    if (parseInt(prestacion.unidad_de_medida_max) > 1 ) {
      div_cantidad_de_unidades.css('display', 'inline-block');
      div_cantidad_de_unidades.append('<label for="prestacion_brindada_cantidad_de_unidades">'+prestacion.unidad_de_medida_nombre+'*</label>');
      div_cantidad_de_unidades.append('<input id="prestacion_brindada_cantidad_de_unidades" name="prestacion_brindada[cantidad_de_unidades]" size="6" type="text">');
    }
    else{
      div_cantidad_de_unidades.css('display', 'none');
      div_cantidad_de_unidades.append('<input id="prestacion_brindada_cantidad_de_unidades" name="prestacion_brindada[cantidad_de_unidades]" size="6" type="text" value="1.0">');
    }

    //#atributos_reportables
    div_atributos = $('#atributos_reportables').empty();
    if (datos_reportables.length > 0) {
      div_atributos.append('<h3>Atributos Reportables</h3>');
      
      for (var i = 0; i < datos_reportables.length; i++) {
        var div_padre;
        // Me fijo si el atributo corresponde a algun grupo
        if (datos_reportables[i].nombre_de_grupo.length > 0 ) {
          // Si corresponde, busco si ya esta creado
          div_grupo = $("#titulo_de_grupo_"+ datos_reportables[i].codigo_de_grupo);
          if ( div_grupo.length == 0 ) {
            //No existe, creo el div
            div_atributos.append('<div id="titulo_de_grupo_'+ datos_reportables[i].codigo_de_grupo + '"><h4>'+ datos_reportables[i].nombre_de_grupo +'</h4></div>');
            div_padre = $("#titulo_de_grupo_"+ datos_reportables[i].codigo_de_grupo);
          }
          else
           div_padre = div_grupo;
        } 
        else // Si no corresponde a ningun grupo, lo pongo a la bartola
          div_padre = div_atributos;

        //Nombre y id de dato reportable requerido
        id_dato_reportable_requerido = "prestacion_brindada_datos_reportables_asociados_attributes_" + i.toString() + "_dato_reportable_requerido_id";
        nombre_dato_reportable_requerido = "prestacion_brindada[datos_reportables_asociados_attributes][" + i.toString() + "][dato_reportable_requerido_id]";

        //Nombre y id de dato reportable asociado
        id_html = "prestacion_brindada_datos_reportables_asociados_attributes_" + i.toString() + "_valor_" + datos_reportables[i].tipo;
        nombre_html = "prestacion_brindada[datos_reportables_asociados_attributes][" + i.toString() + "][valor_"+ datos_reportables[i].tipo +"]";

        var html_campo = "";
        html_campo +='<input id="'+id_dato_reportable_requerido+'" name="'+nombre_dato_reportable_requerido+'" type="hidden" value="'+datos_reportables[i].dato_reportable_id+'">';
        html_campo += '<div class="field">';
        html_campo += '  <label for="'+id_html+'">'+ datos_reportables[i].nombre +'</label>';

        if (datos_reportables[i].enumerable) {
          html_campo += '<select id="'+ id_html+'" name="'+ nombre_html+'" class="multi_select" style="width: 500px;" data-placeholder="Seleccione una opción...">';
          html_campo += '<option value="" selected></option>'
          for (var j = 0; j <= datos_reportables[i].valores.length - 1; j++) 
            html_campo += '<option value="'+datos_reportables[i].valores[j].id+'">'+datos_reportables[i].valores[j].nombre+'</option>';
          html_campo += '</select>';
        }
        else
        {
          switch(datos_reportables[i].tipo){
            case "integer":
            html_campo += '<input type="text" id="'+ id_html+'" name="'+ nombre_html +'" class="solo_numeros">';
            break;
   
            case "big_decimal":
            html_campo += '<input type="text" id="'+ id_html+'" name="'+ nombre_html +'">';
            break;

            case "string":
            html_campo += '<input type="text" id="'+ id_html+'" name="'+ nombre_html +'">';
            break;

            case "date":
            html_campo += '<input type="text" id="'+ id_html+'" name="'+ nombre_html +'" class="jquery_fecha">';
            break;
          }
        }
        //div_padre.append(div_field_fin);
        html_campo += "</div>";
        div_padre.append(html_campo);
      } //end for
      //ejecuto los validadores para los campos creados

      $('.jquery_fecha').datepicker({  dateFormat: "yy-mm-dd", showOn: "button", buttonImage: "/assets/calendar.gif", buttonImageOnly: true }); 
      $(".solo_numeros").on("keypress keyup blur",function (event) {
        $(this).val($(this).val().replace(/[^0-9\.]/g,''));
        
        if ((event.which != 46 || $(this).val().indexOf('.') != -1) && (event.which < 48 || event.which > 57) && event.which != 8) 
          event.preventDefault();
      });
      $(".multi_select").chosen({no_results_text: "Ningún resultado concuerda con", allow_single_deselect: true, disable_search_threshold: 10});
    };
  });
  
});

function maquetaPrestaciones(prestacion) {
  var markup = "";
  markup += prestacion.codigo + " - " + prestacion.nombre;

  return markup;
}

function maquetaPrestacionesSeleccionadas(prestacion) {
  var markup = "";

  markup += prestacion.codigo + " - " + prestacion.nombre ;

  if (refrescar) {
    $("#prestacion_brindada_prestacion_id").trigger('change');
    refrescar = false;
  };
  return markup;

}

function maquetaDiagnosticos(diagnostico) {
  var markup = "";
  markup += diagnostico.nombre;

  return markup;
}

function maquetaDiagnosticosSeleccionados(diagnostico) {
  var markup = "";

  markup += diagnostico.nombre ;

  return markup;
}