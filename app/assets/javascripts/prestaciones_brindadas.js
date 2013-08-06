//= require prestaciones.js
//= require unidades_de_medida.js
//= require datos_reportables_requeridos.js
//= require diagnosticos.js
//= require diagnosticos_prestaciones.js
//= require datos_reportables.js
//= require si_no.js
//= require efectores.js

/* var oOpcionesPrestaciones = [];
var sFiltroPrestaciones = "";
var oOpcionesDiagnosticos = [];
var sFiltroDiagnosticos = "";
var oOpcionesFiltradas = [];
*/

$(document).ready(function() {

  modificarVisibilidadDiagnosticos();
  modificarVisibilidadCantidad();
  modificarVisibilidadEsCatastrofica();
  modificarVisibilidadDatosReportables();

  $('#prestacion_brindada_prestacion_id').on('change', prestacion_id_changed);
  $('#prestacion_brindada_prestacion_id').focus();

/*  function modificar_filtro_prestacion(event) {

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
    //$('#prestacion_brindada_prestacion_id').on('keyup', modificar_filtro_prestacion);
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
    //$('#prestacion_brindada_diagnostico_id').on('keyup', modificar_filtro_diagnostico);
    $('#prestacion_brindada_diagnostico_id').focus();
  }

  // Extraído del MDN Javascript Guide
  function escapeRegExp(string){
    return string.replace(/([.*+?^=!:${}()|[\]\/\\])/g, "\\$1");
  }
*/

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
      div_html = "<label for=\"prestacion_brindada_diagnostico_id\">Diagnóstico*</label>\n<select id=\"prestacion_brindada_diagnostico_id\" name=\"prestacion_brindada[diagnostico_id]\" placeholder=\"Seleccione una opción\">\n<option selected=\"selected\" value=\"\"></option>\n";
      for (i = 0; i < nDiagnosticosAsociados; i++)
        div_html += "<option value=\"" + oDiagnosticosAsociados[i].id + "\">" + oDiagnosticosAsociados[i].nombre_y_codigo + "</option>\n";
      div_html += "</select>\n"
      $('#diagnostico').html(div_html);
      $('#prestacion_brindada_diagnostico_id').chosen({width: "600px", no_results_text: "Ningún resultado concuerda con", allow_single_deselect: true});
//      $('#prestacion_brindada_diagnostico_id').on('keyup', modificar_filtro_diagnostico);
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

  function modificarVisibilidadHistoriaClinica() {
  	var prestacion_id = $('#prestacion_brindada_prestacion_id').val();

  	if (prestacion_id > 0)
      for (i = 0; i < prestaciones.length; i++)
        if (prestacion_id == prestaciones[i].id) {
          if (!prestaciones[i].comunitaria)
        	  $('#historia_clinica').show();
          else
		        $('#historia_clinica').hide();
          break;
        }
    else
      $('#historia_clinica').hide();
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
    var oDatosReportablesAsociados = [];
    var nIndiceDra = 0;
    var div_html = "";

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
        var anio = datosReportablesRequeridos[i].fecha_de_inicio.substring(0, 4);
        var mes = datosReportablesRequeridos[i].fecha_de_inicio.substring(5, 7);
        var dia = datosReportablesRequeridos[i].fecha_de_inicio.substring(8, 10);
        oDatosReportablesAsociados[nIndiceDra++] = {
          "id" : datosReportablesRequeridos[i].id,
          "fecha_de_inicio" : new Date(anio, mes, dia),
          "obligatorio" : datosReportablesRequeridos[i].obligatorio,
          "dato_reportable" : datosReportables[j]
        }
      }
    }

    if (nIndiceDra > 0) {
      div_html += "<h3>Atributos reportables</h3>\n";
      for (i = 0; i < nIndiceDra; i++) {
        if ( oDatosReportablesAsociados[i].dato_reportable.integra_grupo && oDatosReportablesAsociados[i].dato_reportable.orden_de_grupo == 1 ) {
          // Añadir el subtítulo del grupo de datos
          div_html += "<div id=\"titulo_grupo_" + oDatosReportablesAsociados[i].dato_reportable.codigo_de_grupo + "\">\n"
          div_html += "  <h4>" + oDatosReportablesAsociados[i].dato_reportable.nombre_de_grupo + "</h4>\n";
          div_html += "</div>\n";
        }

        // Añadir el campo oculto con el ID del DatoReportableRequerido
        div_html += "<input id=\"prestacion_brindada_datos_reportables_asociados_attributes_" + i + "_dato_reportable_requerido_id\"";
        div_html += " name=\"prestacion_brindada[datos_reportables_asociados_attributes][" + i + "][dato_reportable_requerido_id]\"";
        div_html += " type=\"hidden\" value=\"" + oDatosReportablesAsociados[i].id + "\" />\n";

        // Verificar si este campo tiene errores y guardar su valor para establecerlo luego
        var field_error = false;
        for ( j = 0; j < dDatosReportablesAsociados.length; j++ )
          if ( dDatosReportablesAsociados[j].dato_reportable_requerido_id == oDatosReportablesAsociados[i].id ) {
            if ( Object.keys(dDatosReportablesAsociados[j].errors).length > 0 )
              field_error = true;
            break;
          }

        // Crear el DIV que aloja la etiqueta y el campo
        div_html += "<div class='field' id='dato_reportable_requerido_" + oDatosReportablesAsociados[i].id + "'>\n";

        // Crear la etiqueta
        if ( field_error )
          div_html += "<div class=\"field_with_errors\">";
        div_html += "  <label for=\"prestacion_brindada_datos_reportables_asociados_attributes_" + i + "_valor_";
        div_html += oDatosReportablesAsociados[i].dato_reportable.tipo_ruby + "\">";
        div_html += oDatosReportablesAsociados[i].dato_reportable.nombre;
        if ( oDatosReportablesAsociados[i].obligatorio ) {
          div_html += "*";
        }
        div_html += "</label>";

        if ( field_error ) {
          div_html += "</div>\n";
          div_html += "<div class=\"field_with_errors\">";
        }
        else
          div_html += "\n";

        // Definir una variable para almacenar el valor actual escrito en el control
        var valor = null;

        // Si el campo corresponde a un dato enumerable (modelo secundario), construir un SELECT que permita seleccionar
        // la opción correspondiente
        if ( oDatosReportablesAsociados[i].dato_reportable.enumerable ) {
          for ( j = 0; j < dDatosReportablesAsociados.length; j++ )
            if ( dDatosReportablesAsociados[j].dato_reportable_requerido_id == oDatosReportablesAsociados[i].id ) {
              valor = dDatosReportablesAsociados[j].valor_integer;
              break;
            }
          div_html += "<select id=\"prestacion_brindada_datos_reportables_asociados_attributes_" + i + "_valor_integer\"";
          div_html += "name=\"prestacion_brindada[datos_reportables_asociados_attributes][" + i + "][valor_integer]\" placeholder=\"Seleccione una opción\">\n";
          if ( valor )
            div_html += "<option value=\"\"></option>\n";
          else
            div_html += "<option value=\"\" selected=\"selected\"></option>\n";

          enumeracion = eval(oDatosReportablesAsociados[i].dato_reportable.clase_para_enumeracion);
          for (j = 0; j < enumeracion.length; j++)
            if ( valor == enumeracion[j].id )
              div_html += "<option value=\"" + enumeracion[j].id + "\" selected=\"selected\">" + enumeracion[j].nombre + "</option>\n";
            else
              div_html += "<option value=\"" + enumeracion[j].id + "\">" + enumeracion[j].nombre + "</option>\n";
          div_html += "</select>";
        }
        else {
          switch ( oDatosReportablesAsociados[i].dato_reportable.tipo_ruby ) {
            case "date":
              for ( j = 0; j < dDatosReportablesAsociados.length; j++ )
                if ( dDatosReportablesAsociados[j].dato_reportable_requerido_id == oDatosReportablesAsociados[i].id ) {
                  valor = dDatosReportablesAsociados[j].valor_date;
                  break;
                }

              // Si el campo es de tipo "date", crear los select para ingresar una fecha
              div_html += "<select id=\"prestacion_brindada_datos_reportables_asociados_attributes_" + i + "_valor_date_3i\"";
              div_html += "name=\"prestacion_brindada[datos_reportables_asociados_attributes][" + i + "][valor_date(3i)]\">\n";
              if ( valor )
                div_html += "<option value=\"\"></option>\n";
              else
                div_html += "<option value=\"\" selected=\"selected\"></option>\n";
              for ( j = 1; j <= 31; j++ )
                if ( valor && valor.substring(8, 10) == j )
                  div_html += "<option value=\"" + j + "\" selected=\"selected\">" + j + "</option>\n";
                else
                  div_html += "<option value=\"" + j + "\">" + j + "</option>\n";
              div_html += "</select>\n";
              div_html += "<select id=\"prestacion_brindada_datos_reportables_asociados_attributes_" + i + "_valor_date_2i\"";
              div_html += "name=\"prestacion_brindada[datos_reportables_asociados_attributes][" + i + "][valor_date(2i)]\">\n";
              if ( valor )
                div_html += "<option value=\"\"></option>\n";
              else
                div_html += "<option value=\"\" selected=\"selected\"></option>\n";

              var aMeses = [ "enero", "febrero", "marzo", "abril", "mayo", "junio", "julio", "agosto", "setiembre", "octubre", "noviembre", "diciembre"]
              for ( j = 0; j < 12; j++ )
                if ( valor && (valor.substring(5, 7) - 1) == j )
                  div_html += "<option value=\"" + (j + 1) + "\" selected=\"selected\">" + aMeses[j] + "</option>\n";
                else
                  div_html += "<option value=\"" + (j + 1) + "\">" + aMeses[j] + "</option>\n";
              div_html += "</select>\n";

              var hoy = new Date();
              var anio_final = hoy.getFullYear() + 1;
              div_html += "<select id=\"prestacion_brindada_datos_reportables_asociados_attributes_" + i + "_valor_date_1i\"";
              div_html += "name=\"prestacion_brindada[datos_reportables_asociados_attributes][" + i + "][valor_date(1i)]\">\n";
              if ( valor )
                div_html += "<option value=\"\"></option>\n";
              else
                div_html += "<option value=\"\" selected=\"selected\"></option>\n";
              for ( j = 2012; j <= anio_final; j++ )
                if ( valor && valor.substring(0, 4) == j )
                  div_html += "<option value=\"" + j + "\" selected=\"selected\">" + j + "</option>\n";
                else
                  div_html += "<option value=\"" + j + "\">" + j + "</option>\n";
              div_html += "</select>";
              break;

            default:
              // En forma predeterminada se utiliza una caja de entrada de texto
              for ( j = 0; j < dDatosReportablesAsociados.length; j++ )
                if ( dDatosReportablesAsociados[j].dato_reportable_requerido_id == oDatosReportablesAsociados[i].id ) {
                  valor = eval("dDatosReportablesAsociados[j].valor_" + oDatosReportablesAsociados[i].dato_reportable.tipo_ruby);
                  break;
                }
              div_html += "<input id=\"prestacion_brindada_datos_reportables_asociados_attributes_" + i + "_valor_";
              div_html += oDatosReportablesAsociados[i].dato_reportable.tipo_ruby + "\"";
              div_html += " name=\"prestacion_brindada[datos_reportables_asociados_attributes][" + i + "][valor_";
              div_html += oDatosReportablesAsociados[i].dato_reportable.tipo_ruby + "]\" type=\"text\""
              if ( valor != null )
                div_html += " value=\"" + valor + "\"";
              div_html += " />";
              break;
          }
        }

        if ( field_error )
          div_html += "</div>\n";
        else
          div_html += "\n";

        // Cerrar el DIV que aloja la etiqueta y el campo
        div_html += "</div>\n";
      }
    }

    $("#atributos_reportables").html(div_html);

    // Establecer el valor de los distintos campos, si se han pasado datos

    return;
  }

  function prestacion_id_changed() {
  	modificarSelectDiagnosticos();
    modificarInputCantidad();
    modificarVisibilidadEsCatastrofica();
    modificarVisibilidadHistoriaClinica();
    modificarVisibilidadDatosReportables();
  }

});
