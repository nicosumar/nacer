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
    return validarPasos(context.fromStep);
  }

  function validarPasos(paso){
    var esValido = true;
    switch(paso) {
      case 1:
        if( $("#pago_sumar_efector_id").select2('val') == "" || $("#pago_sumar_concepto_de_facturacion_id").select2('val') == ""){
          alert("Seleccione el efector y concepto a pagar");
          esValido =  false;
        }
        break;
      
      case 2:
        if($("#pago_sumar_expedientes_sumar").select2("val").length <= 1){
          alert("Debe seleccionar al menos a un expediente a pagar");
          esValido = false;
        }
        break;
      
      case 3:
        if($("#pago_sumar_cuenta_bancaria_destino_id").select2("val")=="" || $("#pago_sumar_cuenta_bancaria_origen_id").select2("val")==""){
          alert("Seleccione las cuentas de origen y destino de los fondos");
          esValido = false;
        }
        break;
      
      default:
        esValido = true;
    }
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
    var efector  = $("#pago_sumar_efector_id");
    var concepto = $("#pago_sumar_concepto_de_facturacion_id");
    var expedientes = $("#pago_sumar_expedientes_sumar");
    var notas_de_debito = $("#notas_de_debito");
    var cuenta_bancaria_origen = $("#pago_sumar_cuenta_bancaria_origen_id");
    var cuenta_bancaria_destino = $("#pago_sumar_cuenta_bancaria_destino_id");
  
    //divs
    var div_efector_y_concepto = $("#efector_y_concepto");
    var div_cuentas_bancarias = $("#cuentas_bancarias");
  
    if(efector.select2("data") != null)
     div_efector_y_concepto.html("<h3>" +efector.select2("data").text + " - " +concepto.select2("data").text +"</h3>");
  }
} 

function maquetaExpedientes(expediente) {
    var markup = "";
    markup += "<b>"+ expediente.numero + "</b> ($ "+ expediente.monto_aprobado + ")";

    return markup;
}

function maquetaExpedientesSeleccionados(expediente) {
  var markup = "";
  var resumen_markup = "";
  var div_expedientes_y_nd = $("#expedientes_y_nd");

  markup += "<b>"+ expediente.numero + " - " + expediente.periodo + "</b> ($ "+ expediente.monto_aprobado + ")";
  
  //Aprovecho y genero el resumen:
  resumen_markup += "<b>Expediente Nº:</b>" + expediente.numero + "<br>";
  resumen_markup += "<b>Periodo de liquidación</b>: " + expediente.periodo + "<br>";
  resumen_markup += "<b>Total Aprobado:</b> $" + expediente.monto_aprobado + "<br>";
  if(div_expedientes_y_nd.html()){
    resumen_markup += "<br>";
    div_expedientes_y_nd.html(div_expedientes_y_nd.html() + resumen_markup);
  }
  else
    div_expedientes_y_nd.html(resumen_markup);

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