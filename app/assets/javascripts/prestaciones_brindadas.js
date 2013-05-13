//= require prestaciones.js
//= require unidades_de_medida.js
//= require datos_reportables_requeridos.js
//= require diagnosticos.js
//= require diagnosticos_prestaciones.js

$(document).ready(function() {

  modificarVisibilidadDiagnosticos();
  modificarVisibilidadCantidad();
  modificarVisibilidadEsCatastrofica();
  modificarVisibilidadDatosReportables();

  $('#prestacion_brindada_prestacion_id').on('change', prestacion_id_changed);

  function modificarVisibilidadDiagnosticos() {
  	var prestacion_id = $('#prestacion_brindada_prestacion_id').val();
    var nDiagnosticosAsociados = 0;
    var oDiagnosticosAsociados = [];
    for (i = 0; i < diagnosticosPrestaciones.length; i++) {
      if (prestacion_id == diagnosticosPrestaciones[i].prestacion_id) {
      	for (j = 0; j < diagnosticos.length; j++)
      	  if (diagnosticos[j].id == diagnosticosPrestaciones[i].diagnostico_id)
      	    break;
      	oDiagnosticosAsociados[nDiagnosticosAsociados] = {
      	  "id" : diagnosticos[j].id,
      	  "nombre_y_codigo" : diagnosticos[j].nombre_y_codigo
      	}
        nDiagnosticosAsociados += 1;
      }
    }
    if (nDiagnosticosAsociados > 1) {
      div_html = "<label for=\"prestacion_brindada_diagnostico_id\">Diagnóstico*</label>\n<select id=\"prestacion_brindada_diagnostico_id\" name=\"prestacion_brindada[diagnostico_id]\"><option selected=\"selected\" value=\"\"></option>";
      for (i = 0; i < nDiagnosticosAsociados; i++)
        div_html += "<option value=\"" + oDiagnosticosAsociados[i].id + "\">" + oDiagnosticosAsociados[i].nombre_y_codigo + "</option>";
      $('#diagnostico').html(div_html);
      $('#diagnostico').show();
    }
    else if (nDiagnosticosAsociados > 0) {
      div_html = "<input id=\"prestacion_brindada_diagnostico_id\" name=\"prestacion_brindada[diagnostico_id]\" type=\"hidden\" value=\""
      div_html += oDiagnosticosAsociados[0].id + "\" />\n"
      div_html += "<div class='field_content'>\n"
      div_html += "  <span class='field_name'>Diagnóstico*</span>\n"
      div_html += "  <span class='field_value'>" + oDiagnosticosAsociados[0].nombre_y_codigo + "</span>\n"
      div_html += "</div>"
      $('#diagnostico').html(div_html);
      $('#diagnostico').show();
    }
    else
      $('#diagnostico').hide();
  }

  function modificarVisibilidadCantidad() {
  	var prestacion_id = $('#prestacion_brindada_prestacion_id').val();
    for (i = 0; i < prestaciones.length; i++)
      if (prestacion_id == prestaciones[i].id) {
	    for (j = 0; j < unidadesDeMedida.length; j++)
	      if (unidadesDeMedida[j].codigo == prestaciones[i].codigo_de_unidad)
	        break;
	    if (prestaciones[i].codigo_de_unidad != "U") {
	      $('#prestacion_brindada_cantidad_de_unidades').val("");
	      $('label[for="prestacion_brindada_cantidad_de_unidades"]').text("Cantidad de " + unidadesDeMedida[j].nombre.toLowerCase() + "*")
	      $('#cantidad_de_unidades').show();
	    }
	    else {
	      $('#cantidad_de_unidades').hide();
	      $('#prestacion_brindada_cantidad_de_unidades').val("1.0");
	    }
        break;
      }
  }

  function modificarVisibilidadEsCatastrofica() {
  	var prestacion_id = $('#prestacion_brindada_prestacion_id').val();
    for (i = 0; i < prestaciones.length; i++)
      if (prestacion_id == prestaciones[i].id) {
      	if (!prestaciones[i].define_si_es_catastrofica)
      	  $('#es_catastrofica').show();
      	else
      	  $('#es_catastrofica').hide();
        break;
      }
  }

  function modificarVisibilidadDatosReportables() {
    // Primero ocultamos todos los elementos
    $('#titulo_atributos').hide();
    $('div[id^="dato_reportable_"]').hide();
    $('div[id^="titulo_grupo_"]').hide();

    // Luego mostramos únicamente los que estén asociados con esta prestación
    prestacion_id = $('#prestacion_brindada_prestacion_id').val();
    for (i = 0; i < datosReportablesRequeridos.length; i++)
    {
      if (datosReportablesRequeridos[i].prestacion_id == prestacion_id)
      {
      	// Mostrar el título de esta sección del formulario, si todavía estaba oculta
      	if (!$('#titulo_atributos').is(':visible'))
      	  $('#titulo_atributos').show();

      	// Mostrar el titulo del grupo, si el dato reportable pertenece a uno
      	if (datosReportablesRequeridos[i].codigo_de_grupo != null)
      	  $('#titulo_grupo_' + datosReportablesRequeridos[i].codigo_de_grupo).show();

        // Modificar la etiqueta asociada al dato reportable si es obligatorio (añadir el asterisco)
	    var l = $("#dato_reportable_" + datosReportablesRequeridos[i].dato_reportable_id + " label");
        if (datosReportablesRequeridos[i].obligatorio)
        {
          if (/([^\*])$/.test(l.text()))
            l.text(l.text() + "*");
        }
        else
          l.text(l.text().replace(/\*$/, ""));

        // Mostrar el dato reportable
      	$('#dato_reportable_' + datosReportablesRequeridos[i].dato_reportable_id).show();
      }
    }
  }

  function prestacion_id_changed() {
    modificarVisibilidadDiagnosticos();
    modificarVisibilidadDatosReportables();
    modificarVisibilidadCantidad();
    modificarVisibilidadEsCatastrofica();
  }

});
