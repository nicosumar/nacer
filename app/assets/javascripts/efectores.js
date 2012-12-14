// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require distritos.js
//= require codigos_postales.js

$(document).ready(function() {

  modificarVisibilidadFechaAddendaPerinatal();
  modificarVisibilidadAddendaPerinatal();

  $('#efector_departamento_id').bind('change', modificarSelectDistritos);
  $('#efector_distrito_id').bind('change', modificarCodigoPostal);
  $('#efector_perinatal_de_alta_complejidad').bind('change', modificarVisibilidadAddendaPerinatal);
  $('#efector_addenda_perinatal').bind('change', modificarVisibilidadFechaAddendaPerinatal);

  function modificarSelectDistritos() {
    departamento_id = $('#efector_departamento_id').val();
    div_html = ""
    for (i = 0; i < departamentosDistritos.length; i++)
    {
      if (departamentosDistritos[i].departamento_id == departamento_id)
      {
        div_html += "<label for=\"efector_distrito_id\">Distrito</label>\n<select id=\"efector_distrito_id\" name=\"efector[distrito_id]\"><option selected=\"selected\" value=\"\"></option>";
        for (j = 0; j < departamentosDistritos[i].distritos.length; j++)
          div_html += "<option value=\"" + departamentosDistritos[i].distritos[j].distrito_id + "\">" + departamentosDistritos[i].distritos[j].distrito_nombre + "</option>";
        break;
      }
    }
    $('#select_distritos').html(div_html)
    $('#efector_distrito_id').bind('change', modificarCodigoPostal);
    $('#efector_distrito_id').focus();
  }

  function modificarCodigoPostal() {
    distrito_id = $('#efector_distrito_id').val();

    for (i = 0; i < codigosPostales.length; i++)
      if (codigosPostales[i].distrito_id == distrito_id)
      {
        $('#efector_codigo_postal').val(codigosPostales[i].codigo_postal);
        break;
      }
  }

  function modificarVisibilidadFechaAddendaPerinatal() {
    if ($('#efector_addenda_perinatal').attr('checked'))
    {
      $('#fecha_de_addenda_perinatal').show();
      $('#efector_fecha_de_addenda_perinatal').focus();
    }
    else
      $('#fecha_de_addenda_perinatal').hide();
  }

  function modificarVisibilidadAddendaPerinatal() {
    if ($('#efector_perinatal_de_alta_complejidad').attr('checked'))
    {
      $('#addenda_perinatal').show();
      $('#efector_addenda_perinatal').focus();
    }
    else
      $('#addenda_perinatal').hide();
  }

});
