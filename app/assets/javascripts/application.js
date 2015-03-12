// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require cocoon
//= require select2
//= require select2_locale_es
//= require jquery.ui.datepicker
//= require jquery.ui.spinner
//= require jquery.ui.dialog
//= require jquery.ui.tabs
//= require jquery.ui.tooltip
//= require jquery.ui.effect-highlight
//= require jquery.ui.all
//= require chosen-jquery
//= require wice_grid 


$(document).ready(function() {
  $('.multi_select').chosen({no_results_text: "Ningún resultado concuerda con", allow_single_deselect: true, disable_search_threshold: 10});
  $('input[type="submit"]').attr("data-disable-with", "Por favor, espere...");
});

//Transforma una cadena en json 
function JSONize(str) {
  return str
    // agrega comillas a las llaves de un string 
    .replace(/([\$\w]+)\s*:/g, function(_, $1){return '"'+$1+'":'})    
    // reemplaza las comillas simples por dobles en los valores
    .replace(/'([^']+)'/g, function(_, $1){return '"'+$1+'"'})         
}

//TODO: Para browsers mas viejos usar "void 0" en lugar de la keyword undefined. Testearlo despues
$(document).ready(function() {
  $('.select2').each(function(i, e){
    var select = $(e);
    options = {
      minimumInputLength: (select.data('caracteresminimos') == undefined) ? '0' : select.data('caracteresminimos'),
      allowClear: true,
      dropdownCssClass: "bigdrop",
      width: 'resolve',
      dropdownAutoWidth : true
    };

    //;
    if(select.data('funcion-de-formato') != undefined || select.data('funcion-de-formato') != "") {
      options.formatResult = eval(select.data('funcion-de-formato'));
      options.formatSelection = eval(select.data('funcion-de-formato-seleccionada'));
    } 
    // Agrega las opciones adicionales de creacion.
    // TODO: reemplazar por $.extend y sacar el eval
    if( select.data('opciones') != undefined){
      opc = select.data('opciones');
      for(var o in opc)
        eval("options."+ o +" = opc."+o );
    }

    if (select.hasClass('ajax')) {
      if (select.data('parametros-adicionales') == undefined )
        select.data('parametros-adicionales',  '');
      
      options.ajax = {
        url: select.data('source'),
        dataType: 'json',
        quietMillis: 170,
        data: function(term, page) { 
          ret = {
            q: term,
            page: page,
            per: 10,
            // DEPRECATION WARNING:
            // envio los parametros adicionales como valores - Dejo el array tambien para compatibilidad hacia atras
            parametros_adicionales: (select.data('parametros-adicionales') == undefined) ? '' : eval("({"+ select.data('parametros-adicionales') + "})")
          }
          
          var params = {};
          if( select.data('parametros-adicionales') != undefined){
            //Convierto los datos adicionales en un obj
            params = jQuery.parseJSON( JSONize("{"+ select.data('parametros-adicionales') + "}")  );
          }
          //agrego los parametros adicionales al obj sin estar en el array
          $.extend( ret, ret, params );
          return ret 
        },
        results: function(data, page) { return { more: data.total > (page * 10), results: eval("data." + select.data('coleccion'))} }
      }
    } // end if (select.hasClass('ajax')) {

    options.dropdownCssClass = "bigdrop";

    if(select.hasClass('dependiente') && select.data('id-padre') != undefined )
    {
      //Busco los padres:
      padres = []
      if($.trim(select.data('parametros-adicionales')) == "")
        parametros_adicionales = [];
      else 
        parametros_adicionales = $.trim(select.data('parametros-adicionales')).split(",");

      $.each(select.data('id-padre').split(","), function(indice, padre_id){
        padre = $("#"+$.trim(padre_id));
        
        //Si lo encuentra
        if(padre.length)
        {
          padres.push(padre)
          //Guardo los parametros adicionales estaticos y agrego el id de este padre en los parametros adicionales
          
          padre_val = ' -1';
          if (padre.val() !== undefined && padre.val() != '' ) 
            padre_val = " "+ padre.val();

          parametros_adicionales.push($.trim(padre_id)+':'+padre_val);
          select.data('parametros-adicionales', parametros_adicionales.join(","))
          
          //A cada padre lo seteo para que cuando cambie el valor, actualice los parametros que envia via ajax
          padres[indice].change( function(evt){
            
            arr_parametros_adicionales = [];
            $.each(select.data('parametros-adicionales').split(","),function(idx_parametro, parametro){
              //reconstruyo el string de parametros adicionales cambiando solo el nuevo valor del padre
              nombre_parametro = $.trim(parametro.split(":")[0]);
              valor_parametro  = $.trim(parametro.split(":")[1]);
              //Si no paso parametros adicionales
              if(nombre_parametro.length != 0)
              {
                if(nombre_parametro == evt.currentTarget.id)
                  valor_parametro = evt.currentTarget.value;
                arr_parametros_adicionales.push(nombre_parametro+":"+valor_parametro+" ");
              }
            }); //end each parametros-adicionales
            select.data('parametros-adicionales', arr_parametros_adicionales.join(",") );
          }); //end on change
          //Disparo el change para que si los padres ya tenian valores, le setee el valor a este depediente
          padre.trigger("change");
        } // end if (si encontro el padre)
        else
          throw "No se encontro el elemento: "+"'"+padre_id+"'";
      });//end each padre
    } //end class dependiente

    /*
       Verifica si el select2 tiene una opcion de multiple. Si es asi
      cambia el string q crea select2 por un array de ints
    */
    if (select.hasClass('ajax') && options.multiple !== undefined && options.multiple == true) {
      options.initSelection =  function (element, callback) {
        var ids = $(element).val();
        if( ids !== ""){
          // Parseo el select2 multiple (ajax), porque los datos los envia como cadena 
          var s_arr_ids = ids.replace("[", "").replace("]", "").split(",");
          var i_arr_ids = new Array();

          // Por cada elemento seleccionado hay que pedirrlo al servidor
          for (var i = 0; i < s_arr_ids.length; i++) {
            i_arr_ids[i] = parseInt(s_arr_ids[i]);
            ret = {
              id:  i_arr_ids[i],
              // DEPRECATION WARNING:
              // envio los parametros adicionales como valores - Dejo el array tambien para compatibilidad hacia atras
              parametros_adicionales: (select.data('parametros-adicionales') == undefined) ? '' : eval("({"+ select.data('parametros-adicionales') + "})")
            }
                
            var params = {};
            if( select.data('parametros-adicionales') != undefined)
              params = jQuery.parseJSON( JSONize("{"+ select.data('parametros-adicionales') + "}")  ); //Convierto los datos adicionales en un obj
            //agrego los parametros adicionales al obj sin estar en el array
            $.extend( ret, ret, params );

            $.ajax({
              url: select.data('source'),
              dataType: "json",
              data: ret
            })
            .done( function(data) { 
              callback(data); 
            });
          }
        } //end if los ids!==""
      } //end function initSelection
    } //end if multiple

    select.select2(options);

    // DEPRECATED: Usar clase dependiente para encadenar distintos Select2
    if(select.hasClass('encadenado') && select.data('id-padre') != undefined && select.data('parametro') !== undefined ){

      select.select2('enable', false);
      select.data('parametros-adicionales', select.data('parametros-adicionales') + ', valor_encadenado: -1')
      padre = $('#'+select.data('id-padre'));

      padre.on('change', function(e){

        var parametros_adicionales = [];

        if (padre.val()=="")
        {
          $.each(select.data('parametros-adicionales').split(","), function(indice, valor){
            
            var parametros = valor.split(":");
           
            if($.trim(parametros[0]) != $.trim('valor_encadenado'))
              parametros_adicionales.push(valor +" ");
            else
              parametros_adicionales.push(valor +" ");
          });
          select.data('parametros-adicionales', parametros_adicionales.join(",") );
          select.select2("val","");
          select.select2('enable', false);
        }
        else
        {

          $.each(select.data('parametros-adicionales').split(","), function(indice, valor){
            var parametros = valor.split(":");
            //Verifico si es un parametro adicional, o el que encadena los combos
            if($.trim(parametros[0]) == $.trim('valor_encadenado'))
              parametros_adicionales.push('valor_encadenado: '+ padre.val() + " ");
            else
              parametros_adicionales.push(valor +" ");
          });
          
          select.data('parametros-adicionales', parametros_adicionales.join(",") );
          select.select2('enable', true);
        }
      });
    }
  })    
});

//Usar la clase "jquery_fecha" para cambiar un input text a jquery con calendar
$(document).ready(function() {
  $('.jquery_fecha').datepicker({  dateFormat: "yy-mm-dd", showOn: "button", buttonImage: "/assets/calendar.gif", buttonImageOnly: true }); 

  $(".solo_numeros").on("keypress keyup blur",function (event) {
    $(this).val($(this).val().replace(/[^0-9\.]/g,''));
    
    if ((event.which != 46 || $(this).val().indexOf('.') != -1) && (event.which < 48 || event.which > 57) && event.which != 8) 
      event.preventDefault();
  });
});

jQuery(function($){
        $.datepicker.regional['es'] = {
                closeText: 'Cerrar',
                prevText: '&#x3c;Ant',
                nextText: 'Sig&#x3e;',
                currentText: 'Hoy',
                monthNames: ['Enero','Febrero','Marzo','Abril','Mayo','Junio',
                'Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre'],
                monthNamesShort: ['Ene','Feb','Mar','Abr','May','Jun',
                'Jul','Ago','Sep','Oct','Nov','Dic'],
                dayNames: ['Domingo','Lunes','Martes','Mi&eacute;rcoles','Jueves','Viernes','S&aacute;bado'],
                dayNamesShort: ['Dom','Lun','Mar','Mi&eacute;','Juv','Vie','S&aacute;b'],
                dayNamesMin: ['Do','Lu','Ma','Mi','Ju','Vi','S&aacute;'],
                weekHeader: 'Sm',
                dateFormat: 'yy-mm-dd',
                firstDay: 1,
                isRTL: false,
                showMonthAfterYear: false,
                yearSuffix: ''};
        $.datepicker.setDefaults($.datepicker.regional['es']);
});