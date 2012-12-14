// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require distritos.js
//= require codigos_postales.js

$(document).ready(function() {

  modificarVisibilidadOriginarios();
  modificarVisibilidadEsMenor();
  modificarVisibilidadAlfabBenef();
  modificarVisibilidadAlfabMadre();
  modificarVisibilidadAlfabPadre();
  modificarVisibilidadAlfabTutor();
  modificarVisibilidadEmbarazo();
  modificarVisibilidadEstaEmbarazada();

  $('#novedad_del_afiliado_sexo_id').bind('change', modificarVisibilidadEmbarazo);
// TODO: Ver la conveniencia de modificar la visibilidad de la sección Embarazo con base en la edad
//  $('#novedad_del_afiliado_fecha_de_nacimiento_1i').bind('change', modificarVisibilidadEmbarazo);
//  $('#novedad_del_afiliado_fecha_de_nacimiento_2i').bind('change', modificarVisibilidadEmbarazo);
//  $('#novedad_del_afiliado_fecha_de_nacimiento_3i').bind('change', modificarVisibilidadEmbarazo);
  $('#novedad_del_afiliado_se_declara_indigena').bind('change', modificarVisibilidadOriginarios);
  $('#novedad_del_afiliado_alfabetizacion_del_beneficiario_id').bind('change', modificarVisibilidadAlfabBenef);
  $('#novedad_del_afiliado_domicilio_departamento_id').bind('change', modificarSelectDistritos);
  $('#novedad_del_afiliado_domicilio_distrito_id').bind('change', modificarCodigoPostal);
  $('#novedad_del_afiliado_es_menor').bind('change', modificarVisibilidadEsMenor);
  $('#novedad_del_afiliado_alfabetizacion_de_la_madre_id').bind('change', modificarVisibilidadAlfabMadre);
  $('#novedad_del_afiliado_alfabetizacion_del_padre_id').bind('change', modificarVisibilidadAlfabPadre);
  $('#novedad_del_afiliado_alfabetizacion_del_tutor_id').bind('change', modificarVisibilidadAlfabTutor);
  $('#novedad_del_afiliado_esta_embarazada').bind('change', modificarVisibilidadEstaEmbarazada);

  function modificarVisibilidadOriginarios() {
    if ($('#novedad_del_afiliado_se_declara_indigena').attr('checked'))
    {
      $('#originarios').show();
      $('#novedad_del_afiliado_lengua_originaria_id').focus();
    }
    else
      $('#originarios').hide();
  }

  function modificarVisibilidadAlfabBenef() {
    if ($('#novedad_del_afiliado_alfabetizacion_del_beneficiario_id').val() > 2)
    {
      $('#alfab_benef').show();
      $('#novedad_del_beneficiario_alfab_beneficiario_años_ultimo_nivel').focus();
    }
    else
      $('#alfab_benef').hide();
  }

  function modificarSelectDistritos() {
    departamento_id = $('#novedad_del_afiliado_domicilio_departamento_id').val();
    div_html = ""
    for (i = 0; i < departamentosDistritos.length; i++)
    {
      if (departamentosDistritos[i].departamento_id == departamento_id)
      {
        div_html += "<label for=\"novedad_del_afiliado_domicilio_distrito_id\">Distrito</label>\n<select id=\"novedad_del_afiliado_domicilio_distrito_id\" name=\"novedad_del_afiliado[domicilio_distrito_id]\"><option selected=\"selected\" value=\"\"></option>";
        for (j = 0; j < departamentosDistritos[i].distritos.length; j++)
          div_html += "<option value=\"" + departamentosDistritos[i].distritos[j].distrito_id + "\">" + departamentosDistritos[i].distritos[j].distrito_nombre + "</option>";
        break;
      }
    }
    $('#select_distritos').html(div_html)
    $('#novedad_del_afiliado_domicilio_distrito_id').bind('change', modificarCodigoPostal);
    $('#novedad_del_afiliado_domicilio_distrito_id').focus();
  }

  function modificarCodigoPostal() {
    distrito_id = $('#novedad_del_afiliado_domicilio_distrito_id').val();

    for (i = 0; i < codigosPostales.length; i++)
      if (codigosPostales[i].distrito_id == distrito_id)
      {
        $('#novedad_del_afiliado_domicilio_codigo_postal').val(codigosPostales[i].codigo_postal);
        break;
      }
  }

  function modificarVisibilidadEsMenor() {
    if ($('#novedad_del_afiliado_es_menor').attr('checked'))
    {
      $('#es_menor').show();
      $('#novedad_del_afiliado_esta_embarazada').attr('checked', false);
      $('#embarazo').hide();
    }
    else
    {
      $('#es_menor').hide();
      if ($('#novedad_del_afiliado_sexo_id').val() != 2)
        $('#embarazo').show();
    }
  }

  function modificarVisibilidadAlfabMadre() {
    if ($('#novedad_del_afiliado_alfabetizacion_de_la_madre_id').val() > 2)
    {
      $('#alfab_madre').show();
      $('#novedad_del_beneficiario_alfab_madre_años_ultimo_nivel').focus();
    }
    else
      $('#alfab_madre').hide();
  }

  function modificarVisibilidadAlfabPadre() {
    if ($('#novedad_del_afiliado_alfabetizacion_del_padre_id').val() > 2)
    {
      $('#alfab_padre').show();
      $('#novedad_del_beneficiario_alfab_padre_años_ultimo_nivel').focus();
    }
    else
      $('#alfab_padre').hide();
  }

  function modificarVisibilidadAlfabTutor() {
    if ($('#novedad_del_afiliado_alfabetizacion_del_tutor_id').val() > 2)
    {
      $('#alfab_tutor').show();
      $('#novedad_del_beneficiario_alfab_tutor_años_ultimo_nivel').focus();
    }
    else
      $('#alfab_tutor').hide();
  }

  function modificarVisibilidadEmbarazo() {
    // Ocultar o mostrar la sección dependiendo del sexo del beneficiario
    if ($('#novedad_del_afiliado_sexo_id').val() != 2 && !($('#novedad_del_afiliado_es_menor').attr('checked')))
      $('#embarazo').show();
    else
      $('#embarazo').hide();
  }

  function modificarVisibilidadEstaEmbarazada() {
    if ($('#novedad_del_afiliado_esta_embarazada').attr('checked'))
    {
      $('#esta_embarazada').show();
      $('#novedad_del_afiliado_fecha_de_la_ultima_menstruacion').focus();
    }
    else
      $('#esta_embarazada').hide();
  }

});
