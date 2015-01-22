$(document).ready(function() {
  // Defino el wizzard
  $('#wizard').smartWizard({
    labelNext:'Siguiente', 
    labelPrevious:'Anterior',
    labelFinish:'Finalizar',
    noForwardJumping: true,
    onLeaveStep: verificaDatosCompletos,
    onShowStep: generarResumen
  });

  function verificaDatosCompletos(obj, context){
    return validarPasos(context.fromStep, context.toStep);
  }

  function validarPasos(anterior,proximo){
    var esValido = true;
    if(anterior == 1 && proximo == 2){
      if( $("#pago_sumar_efector_id").select2('val') == "" || $("#pago_sumar_concepto_de_facturacion_id").select2('val') == ""){
          alert("Seleccione el efector y concepto a pagar");
          esValido =  false;
        };
    };
    if (anterior == 2 && proximo == 3) {
      if($("#pago_sumar_expedientes_sumar").select2("val").length <= 1){
        alert("Debe seleccionar al menos a un expediente a pagar");
        esValido = false;
      };
    };
    if (anterior == 3 && proximo == 4) {
      if($("#pago_sumar_cuenta_bancaria_destino_id").select2("val")=="" || $("#pago_sumar_cuenta_bancaria_origen_id").select2("val")==""){
          alert("Seleccione las cuentas de origen y destino de los fondos");
          esValido = false;
        };
    };

    return esValido;
  }

  $("#pago_sumar_concepto_de_facturacion_id").chained("#pago_sumar_efector_id");
  $("#pago_sumar_cuenta_bancaria_destino_id").select2('enable', false);
  
  $("#pago_sumar_cuenta_bancaria_origen_id").on("change", function(e){
    cb = $("#pago_sumar_cuenta_bancaria_origen_id");
    if(cb.select2("val")==""){
      $("#pago_sumar_cuenta_bancaria_destino_id").select2("val","");
      $("#pago_sumar_cuenta_bancaria_destino_id").select2('enable', false);
    }
    else
     $("#pago_sumar_cuenta_bancaria_destino_id").select2('enable', true); 
  });

  

}); 

function generarResumen(obj, context){
  if(context.fromStep == 3 && context.toStep == 4 ){
    //Fields
    var efector  = $("#pago_sumar_efector_id").select2("data");
    var concepto = $("#pago_sumar_concepto_de_facturacion_id").select2("data");
    var expedientes = $("#pago_sumar_expedientes_sumar").select2("data");
    var notas_de_debito = $("#notas_de_debito").select2("data");
    var cuenta_bancaria_origen = $("#pago_sumar_cuenta_bancaria_origen_id").select2("data");
    var cuenta_bancaria_destino = $("#pago_sumar_cuenta_bancaria_destino_id").select2("data");
  
    //divs
    var div_efector_y_concepto = $("#efector_y_concepto");
    var div_cuentas_bancarias = $("#cuentas_bancarias");
    var div_expedientes_y_nd = $("#expedientes_y_nd");
    
    var markup = "";

  
    //alert("Selected value is: "+JSON.stringify($("#notas_de_debito").select2("data")));
    
    markup += "<h3><b>"+efector.text+" - "+concepto.text+"</b></h3>";
    markup += "<h4>Expedientes: </h4>";
    markup += "<ul>";
    for (var i = expedientes.length - 1; i >= 0; i--) {
      markup += "<li><b>Nº: </b>"+ expedientes[i].numero + "</li> ";
      markup += "<li><b>Periodo: </b>"+ expedientes[i].periodo + "</li> ";
      markup += "<li><b>Monto Aprobado: </b>"+ expedientes[i].monto_aprobado + "</li> ";
    };
    markup += "</ul>";
 
    markup += "<h4>Notas de Debito</h4>";
    markup += "<p><ul>";
    for (var i = notas_de_debito.length - 1; i >= 0; i--) {
      markup += "<li><b>"+ notas_de_debito[i].tipo_nombre+ "</b></li> ";
      markup += "<li><b>Nº: </b>"+  notas_de_debito[i].tipo_codigo + "-"+ notas_de_debito[i].numero + "</li> ";
      markup += "<li><b>Monto Original: </b>  $ "+  notas_de_debito[i].monto_original + "</li> ";
      markup += "<li><b>Monto Reservado: </b> $ "+  notas_de_debito[i].monto_reservado + "</li> ";
      markup += "<li><b>Monto Remanente: </b> $ "+  notas_de_debito[i].monto_remanente + "</li> ";
      markup += "<li><b>Monto Disponible: </b>$ "+  notas_de_debito[i].monto_disponible + "</li> ";
    };
    markup += "</ul></p>";

    markup += "<h4>Cuenta Bancarias</h4>";
    markup += "<b>Cuenta Bancaria Origen : </b>"+cuenta_bancaria_origen.text+"<br>";
    markup += "<b>Cuenta Bancaria Destino : </b>"+cuenta_bancaria_destino.nombre+"<br>";

    div_efector_y_concepto.html(markup);
    /*if(efector.select2("data") != null)
     div_efector_y_concepto.html("<h3>" +efector.select2("data").text + " - " +concepto.select2("data").text +"</h3>");
    */
  }
} 

function maquetaExpedientes(expediente) {
    var markup = "";
    markup += "<b>"+ expediente.numero + "</b> ($ "+ expediente.monto_aprobado + ")";

    return markup;
}

function maquetaExpedientesSeleccionados(expediente) {
  var markup = "";

  markup += "<b>"+ expediente.numero + " - " + expediente.periodo + "</b> ($ "+ expediente.monto_aprobado + ")";
  
  return markup;
}

function maquetaNotas(nd) {
  var markup = "";

  markup += "<b>"+ nd.tipo_codigo+ ": Nº " + nd.numero + " - " + "</b> ($ "+ nd.monto_disponible + ")";

  return markup;
}

function maquetaNotasSeleccionadas(nd) {
    var markup = "";
    markup += "<b>"+ nd.tipo_codigo+ ": Nº " + nd.numero + " - " + "</b> ($ "+ nd.monto_disponible + ")";

    return markup;
}

function maquetaCuentasDestino(cb) {
  var markup = "";
  markup += cb.nombre;

  return markup;
}

function maquetaCuentaDestinoSeleccionada(cb) {
    var markup = "";
    markup += cb.nombre;

    return markup;
}