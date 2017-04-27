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
function generar_select2(dom_id){
  var selector = "";
  if(dom_id == undefined)
    selector = '.select2';
  else
    selector = '#' + dom_id;
  
  $(selector).each(function(i, e){
    var select = $(e);
    options = {
      minimumInputLength: (select.data('caracteresminimos') == undefined) ? '0' : select.data('caracteresminimos'),
      allowClear: true,
      dropdownCssClass: "bigdrop",
      width: 'resolve',
      dropdownAutoWidth : true
    };

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

    if (select.hasClass('ajax') ) {
      options.initSelection =  function (element, callback) {
        // Dejo el valor como rails lo envió.
        var ids = $.trim($(element).val());
        
        //  Rails envia los arrays como arrays al value. A select 2 los toma como lista separados x comas,
        // asique reemplazo el array para q select2 no se confunda y duplique elementos en los valores
        $(element).val(ids.replace("[", "").replace("]", "")); //Elimino el valor del value html. 
        
        if( ids !== "[]"){
          ret = { 
            ids: ids,
            // DEPRECATION WARNING:
            // envio los parametros adicionales como valores - Dejo el array tambien para compatibilidad hacia atras
            parametros_adicionales: (select.data('parametros-adicionales') == undefined) ? '' : eval("({"+ select.data('parametros-adicionales') + "})")
          }

          var params = {};
          if( select.data('parametros-adicionales') != undefined)
            params = jQuery.parseJSON( JSONize("{"+ select.data('parametros-adicionales') + "}")  ); //Convierto los datos adicionales en un obj
          //agrego los parametros adicionales al obj sin estar en el array
          $.extend( ret, ret, params );
          // Pasando los args como json puedo hacer una sola llamada ajax y lo agarra el format selection del select2.
          $.ajax({
            url: select.data('source'),
            dataType: "json",
            data: ret
          })
          .done( function(data) { 
            /*
             *  Esta diferencia es porque el select2 es una garcha que manda 
             * los argumentos como array o como objeto dependiendo de la configuracion del
             * select2, en lugar de considerar q simplemente es una llamada ajax.
            */
            if (select.data('opciones').multiple == true) {
              callback( eval("data." + select.data('coleccion')) ); 
            } else{
              callback( eval("data." + select.data('coleccion') + "[0]" ) ); 
            };
          });
        } //end if los ids!=="[]"
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
}

//Usar la clase "jquery_fecha" para cambiar un input text a jquery con calendar
$(document).ready(function() {
  generar_select2();
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