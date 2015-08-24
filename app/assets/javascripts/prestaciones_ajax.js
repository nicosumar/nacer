$(document).ready(function() {
  $('#prestacion_brindada_prestacion_id').on("select2:select", function (e) { 
    alert("alert!!!");
  });

  $('#prestacion_brindada_prestacion_id').on("change", function (e) {
    prestacion = $("#prestacion_brindada_prestacion_id").select2('data');
    datos_reportables = prestacion.datos_reportables;

    //#historia_clinica.field
    div_hc = $('#historia_clinica').empty();
    if (!prestacion.es_comunitaria) {
      div_hc.append('<label for="prestacion_brindada_historia_clinica">Historia clínica / Nº de informe / Nº de solicitud*</label>');
      div_hc.append('<input id="prestacion_brindada_historia_clinica" name="prestacion_brindada[historia_clinica]" size="15" type="text">');
    };

    //#cantidad_de_unidades.field
    div_cantidad_de_unidades = $('#cantidad_de_unidades').empty();
    if (parseInt(prestacion.unidad_de_medida_max) > 1 ) {
      div_cantidad_de_unidades.append('<input id="prestacion_brindada_cantidad_de_unidades" name="prestacion_brindada[cantidad_de_unidades]" size="6" type="text" value="1.0">');
    };
    
    //#atributos_reportables
    if (datos_reportables.length > 0) {
      div_atributos = $('#atributos_reportables').empty();
      div_atributos.append('<h3>Atributos Reportables</h3>');
      
      for (var i = datos_reportables.length - 1; i >= 0; i--) {
    //       /*$.each(f.informes_filtros, function(indice, ifiltro){
    //         if(ifiltro.informe_filtro_validador_ui.tipo == "LOV")
    //         {
    //           $( "#filtros" ).append('<label for="reporte_parametros'+ifiltro.posicion+'">'+ifiltro.nombre+'</label>  ');
    //           $( "#filtros" ).append('<select id="reporte_parametros_'+ifiltro.posicion+'" name="reporte[parametros]['+ifiltro.posicion+']"></select><br>');
    //         }*/
        var div_padre;
        // Me fijo si el atributo corresponde a algun grupo
        if (datos_reportables[i].nombre_de_grupo.length > 0 ) {
          // Si corresponde, busco si ya esta creado
          div_grupo = $("#titulo_de_grupo_"+ datos_reportables[i].nombre_de_grupo.substring(0,2));
          if ( div_grupo.length == 0 ) {
            //No existe, creo el div
            div_atributos.append('<div id="titulo_de_grupo_'+ datos_reportables[i].nombre_de_grupo.substring(0,2) + '"><h4>'+ datos_reportables[i].nombre_de_grupo +'</h4></div>');
            div_padre = $("#titulo_de_grupo_"+ datos_reportables[i].nombre_de_grupo.substring(0,2));
          }
          else
           div_padre = div_grupo;
        } 
        else
        {
          // Si no corresponde a ningun grupo, lo pongo a la bartola
          div_padre = div_atributos;
        };
        
        id_html = "prestacion_brindada_datos_reportables_asociados_attributes_" + i.toString() + "_valor_" + datos_reportables[i].tipo;
        
        nombre_html = "prestacion_brindada[datos_reportables_asociados_attributes][" + i.toString() + "][valor_"+ datos_reportables[i].tipo +"]";
        
        div_field_ini = '<div class="field">';
        div_field_fin = '</div>';
        
        div_padre.append( div_field_ini + '<label for="'+id_html+'">'+ datos_reportables[i].nombre +'</label>  ');
        if (datos_reportables[i].enumerable) {
    
          div_padre.append('<select id="'+ id_html+'" name="'+ nombre_html+'"></select>');
          
          for (var j = 0; i <= datos_reportables[i].valores.length - 1; j++) {
            $("#"+id_html).append($('<option>', { 
                  value: datos_reportables[i].valores[0],
                  text : datos_reportables[i].valores[1]
              }));
          };
          div_padre.append(div_field_fin);
        }
        else
        {
          switch(datos_reportables[i].tipo){
            case "integer":
            div_padre.append('<input type="text" id="'+ id_html+'" name="'+ nombre_html +'" class="solo_numeros"><br>');
            break;
   
            case "big_decimal":
            div_padre.append('<input type="text" id="'+ id_html+'" name="'+ nombre_html +'"><br>');
            break;

            case "string":
            div_padre.append('<input type="text" id="'+ id_html+'" name="'+ nombre_html +'"><br>')
            $("#"+id_html).autoGrowInput({comfortZone: 6, maxWidth: 15});
            break;

            case "date":
            div_padre.append('<input type="text" id="'+ id_html+'" name="'+ nombre_html +'" class="jquery_fecha"><br>');
            break;
          }
        }
        div_padre.append(div_field_fin);
      }
      $('.jquery_fecha').datepicker({  dateFormat: "yy-mm-dd", showOn: "button", buttonImage: "/assets/calendar.gif", buttonImageOnly: true }); 
      $(".solo_numeros").on("keypress keyup blur",function (event) {
        $(this).val($(this).val().replace(/[^0-9\.]/g,''));
        
        if ((event.which != 46 || $(this).val().indexOf('.') != -1) && (event.which < 48 || event.which > 57) && event.which != 8) 
          event.preventDefault();
      });
    };

  /*  enumerable: false
nombre_de_grupo: "Detalle de la internación"
orden: 1
tipo: "integer"*/
    

  //   }
  //   // body...
  //    alert(self);
  //    // prestacion_brindada_datos_reportables_asociados_attributes_0_valor_big_decimal
     
  //    // prestacion_brindada_datos_reportables_asociados_attributes_1_valor_integer

  //    // prestacion_brindada[datos_reportables_asociados_attributes][0][valor_integer]
     
  //    // prestacion_brindada_datos_reportables_asociados_attributes_2_valor_date
  //    // prestacion_brindada_datos_reportables_asociados_attributes_3_valor_string

  //    //tiene asoc
  //    // prestacion_brindada_datos_reportables_asociados_attributes_4_valor_integer
  //     // Access to full data
  //     //console.log($(this).select2('data'));
  
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