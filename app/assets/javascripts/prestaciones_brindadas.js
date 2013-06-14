//= require prestaciones.js
//= require unidades_de_medida.js
//= require datos_reportables_requeridos.js
//= require diagnosticos.js
//= require diagnosticos_prestaciones.js

var oOpcionesPrestaciones = [];
var sFiltroPrestaciones = "";
var oOpcionesDiagnosticos = [];
var sFiltroDiagnosticos = "";
var oOpcionesFiltradas = [];

$(document).ready(function() {

  modificarVisibilidadDiagnosticos();
  modificarVisibilidadCantidad();
  modificarVisibilidadEsCatastrofica();
  modificarVisibilidadDatosReportables();
  $('#prestacion_brindada_prestacion_id').on('change', prestacion_id_changed);
  $('#prestacion_brindada_prestacion_id').on('keyup', modificar_filtro_prestacion);
  $('#prestacion_brindada_diagnostico_id').on('keyup', modificar_filtro_diagnostico);
  $('#prestacion_brindada_prestacion_id').focus();

  function modificar_filtro_prestacion(event) {

    // Guardar el texto y valores de las opciones si es la primera vez
    if ( oOpcionesPrestaciones.length == 0 )
      for ( i = 0; i < $('#prestacion_brindada_prestacion_id option').size(); i++ ) {
        oOpcionesPrestaciones[i] = {
          text : $('#prestacion_brindada_prestacion_id option:eq(' + i + ')').text(),
          val : $('#prestacion_brindada_prestacion_id option:eq(' + i + ')').val(),
        }
      }

    // Añadir el carácter a la cadena del filtro si no es un carácter de control
    if ( event.which == 32 || event.which >= 48 && event.which < 128 ) {
      sFiltroPrestaciones += String.toLowerCase(String.fromCharCode(event.which));
      aplicarFiltroPrestacion();
    }
    else {
      switch (event.which) {
        case 27 :
          sFiltroPrestaciones = "";
          aplicarFiltroPrestacion();
          break;
        case 8 :
          sFiltroPrestaciones = sFiltroPrestaciones.slice(0, -1);
          aplicarFiltroPrestacion();
          break;
      }
    }
  }

  function aplicarFiltroPrestacion() {
    var i;
    var div_html = "<label for=\"prestacion_brindada_prestacion_id\">Prestación*</label>\n<select id=\"prestacion_brindada_prestacion_id\" name=\"prestacion_brindada[prestacion_id]\">";

    if (sFiltroPrestaciones == "")
      oOpcionesFiltradas = oOpcionesPrestaciones;
    else {
      oOpcionesFiltradas = [];
      var regexp = new RegExp(escapeRegExp(sFiltroPrestaciones), "i");
      for ( i = 0; i < oOpcionesPrestaciones.length; i++)
        if ( regexp.test(oOpcionesPrestaciones[i].text) )
          oOpcionesFiltradas.push(oOpcionesPrestaciones[i]);
    }

    if ( oOpcionesFiltradas.length > 0 )
      div_html += "<option selected=\"selected\" value=\"" + oOpcionesFiltradas[0].val + "\">" + oOpcionesFiltradas[0].text + "</option>\n";
    else
      div_html += "<option selected=\"selected\" value=\"\"></option>\n";

    for (i = 1; i < oOpcionesFiltradas.length; i++)
      div_html += "<option value=\"" + oOpcionesFiltradas[i].val + "\">" + oOpcionesFiltradas[i].text + "</option>\n";

    div_html += "</select>\n"

    if ( sFiltroPrestaciones != "" )
      div_html += "<br/>\n<label class=\"filtro\">Filtro actual: \"" + sFiltroPrestaciones + "\" (presione 'ESC' para quitarlo)";

    $('#prestacion').html(div_html);
    $('#prestacion_brindada_prestacion_id').on('change', prestacion_id_changed);
    $('#prestacion_brindada_prestacion_id').on('keyup', modificar_filtro_prestacion);
    $('#prestacion_brindada_prestacion_id').change();
    $('#prestacion_brindada_prestacion_id').focus();
  }

  function modificar_filtro_diagnostico(event) {

    // Guardar el texto y valores de las opciones si es la primera vez
    if ( oOpcionesDiagnosticos.length == 0 )
      for ( i = 0; i < $('#prestacion_brindada_diagnostico_id option').size(); i++ ) {
        oOpcionesDiagnosticos[i] = {
          text : $('#prestacion_brindada_diagnostico_id option:eq(' + i + ')').text(),
          val : $('#prestacion_brindada_diagnostico_id option:eq(' + i + ')').val(),
        }
      }

    // Añadir el carácter a la cadena del filtro si no es un carácter de control
    if ( event.which == 32 || event.which >= 48 && event.which < 128 ) {
      sFiltroDiagnosticos += String.toLowerCase(String.fromCharCode(event.which));
      aplicarFiltroDiagnostico();
    }
    else {
      switch (event.which) {
        case 27 :
          sFiltroDiagnosticos = "";
          aplicarFiltroDiagnostico();
          break;
        case 8 :
          sFiltroDiagnosticos = sFiltroDiagnosticos.slice(0, -1);
          aplicarFiltroDiagnostico();
          break;
      }
    }
  }


  function aplicarFiltroDiagnostico() {
    var i;
    var div_html = "<label for=\"prestacion_brindada_diagnostico_id\">Diagnóstico*</label>\n<select id=\"prestacion_brindada_diagnostico_id\" name=\"prestacion_brindada[diagnostico_id]\">";

    if (sFiltroDiagnosticos == "")
      oOpcionesFiltradas = oOpcionesDiagnosticos;
    else {
      oOpcionesFiltradas = [];
      var regexp = new RegExp(escapeRegExp(sFiltroDiagnosticos), "i");
      for ( i = 0; i < oOpcionesDiagnosticos.length; i++)
        if ( regexp.test(oOpcionesDiagnosticos[i].text) )
          oOpcionesFiltradas.push(oOpcionesDiagnosticos[i]);
    }

    if ( oOpcionesFiltradas.length > 0 )
      div_html += "<option selected=\"selected\" value=\"" + oOpcionesFiltradas[0].val + "\">" + oOpcionesFiltradas[0].text + "</option>\n";
    else
      div_html += "<option selected=\"selected\" value=\"\"></option>\n";

    for (i = 1; i < oOpcionesFiltradas.length; i++)
      div_html += "<option value=\"" + oOpcionesFiltradas[i].val + "\">" + oOpcionesFiltradas[i].text + "</option>\n";

    div_html += "</select>\n"

    if ( sFiltroDiagnosticos != "" )
      div_html += "<br/>\n<label class=\"filtro\">Filtro actual: \"" + sFiltroDiagnosticos + "\" (presione 'ESC' para quitarlo)";

    $('#diagnostico').html(div_html);
    $('#prestacion_brindada_diagnostico_id').on('keyup', modificar_filtro_diagnostico);
    $('#prestacion_brindada_diagnostico_id').focus();
  }

  // Extraído del MDN Javascript Guide
  function escapeRegExp(string){
    return string.replace(/([.*+?^=!:${}()|[\]\/\\])/g, "\\$1");
  }

  function modificarVisibilidadDiagnosticos() {
  	var prestacion_id = $('#prestacion_brindada_prestacion_id').val();
    for (i = 0; i < diagnosticosPrestaciones.length; i++) {
      if (prestacion_id == diagnosticosPrestaciones[i].prestacion_id) {
        $('#diagnostico').show();
        break;
      }
    }
    if (i == diagnosticosPrestaciones.length)
      $('#diagnostico').hide();
  }

  function modificarSelectDiagnosticos() {
  	var prestacion_id = $('#prestacion_brindada_prestacion_id').val();
    var nDiagnosticosAsociados = 0;
    var oDiagnosticosAsociados = [];
    oOpcionesDiagnosticos = [];
    sFiltroDiagnosticos = "";

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
      div_html = "<label for=\"prestacion_brindada_diagnostico_id\">Diagnóstico*</label>\n<select id=\"prestacion_brindada_diagnostico_id\" name=\"prestacion_brindada[diagnostico_id]\">\n<option selected=\"selected\" value=\"\"></option>\n";
      for (i = 0; i < nDiagnosticosAsociados; i++)
        div_html += "<option value=\"" + oDiagnosticosAsociados[i].id + "\">" + oDiagnosticosAsociados[i].nombre_y_codigo + "</option>\n";
      div_html += "</select>\n"
      $('#diagnostico').html(div_html);
      $('#prestacion_brindada_diagnostico_id').on('keyup', modificar_filtro_diagnostico);
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
        if (prestaciones[i].codigo_de_unidad != "U") {
    	    for (j = 0; j < unidadesDeMedida.length; j++)
    	      if (unidadesDeMedida[j].codigo == prestaciones[i].codigo_de_unidad)
    	        break;
	        $('label[for="prestacion_brindada_cantidad_de_unidades"]').text("Cantidad de " + unidadesDeMedida[j].nombre.toLowerCase() + "*")
      	  $('#cantidad_de_unidades').show();
      	}
        else
		      $('#cantidad_de_unidades').hide();
        break;
      }
  }

  function modificarInputCantidad() {
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
	      $('#prestacion_brindada_cantidad_de_unidades').val("1.0000");
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
    //$('#titulo_atributos').hide();
    //$('div[id^="dato_reportable_"]').hide();
    //$('div[id^="titulo_grupo_"]').hide();
    var oDatosReportablesAsociados = [];
    var nIndiceDra = 0;

    // Luego mostramos únicamente los que estén asociados con esta prestación
    prestacion_id = $('#prestacion_brindada_prestacion_id').val();
    for (i = 0; i < datosReportablesRequeridos.length; i++)
    {
      if (datosReportablesRequeridos[i].prestacion_id == prestacion_id)
      {
        for (j = 0; j < datosReportables.length; j++)
          if (datosReportables[j].id == datosReportablesRequeridos[i].dato_reportable_id)
            break;

        // Añadir este DatoReportableRequerido a los asociados a la prestación
        oDatosReportablesAsociados[nIndiceDra] =
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
  	modificarSelectDiagnosticos();
    modificarInputCantidad();
    modificarVisibilidadEsCatastrofica();
    modificarVisibilidadDatosReportables();
  }

});
