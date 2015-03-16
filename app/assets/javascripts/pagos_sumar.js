$(document).ready(function() {
  
  $("#pago_sumar_concepto_de_facturacion_id").chained("#pago_sumar_efector_id");
  //$("#pago_sumar_cuenta_bancaria_destino_id").select2('enable', false);

  $("#pago_sumar_cuenta_bancaria_origen_id").on("change", function(e) {
    cb = $("#pago_sumar_cuenta_bancaria_origen_id");

    if (cb.select2("val") == "") {
      $("#pago_sumar_cuenta_bancaria_destino_id").select2("val", "");
      $("#pago_sumar_cuenta_bancaria_destino_id").select2('enable', false);
    } else
      $("#pago_sumar_cuenta_bancaria_destino_id").select2('enable', true);

  });

  //Si esta editando, habilito el forward jumping y click en los pasos
  if ($("#pago_sumar_efector_id").select2("val") > 0) {
    $("#pago_sumar_efector_id").select2("enable", false);
    noForwardJumping = false;
    enableAllSteps = true;
  }
  else{
    noForwardJumping = true;
    enableAllSteps = false;
  };
  
  if ($("#pago_sumar_concepto_de_facturacion_id").select2("val") > 0)
    $("#pago_sumar_concepto_de_facturacion_id").select2("enable", false);



  // Inicializo el wizzard
  $('#wizard').smartWizard({
    labelNext: 'Siguiente',
    labelPrevious: 'Anterior',
    labelFinish: 'Finalizar',
    noForwardJumping: noForwardJumping,
    enableAllSteps: enableAllSteps,
    onLeaveStep: verificaDatosCompletos,
    onShowStep: generarResumen,
    onFinish: enviarPago,
  });

  function verificaDatosCompletos(obj, context) {
    return validarPasos(context.fromStep, context.toStep);
  }

  function validarPasos(anterior, proximo) {
    var esValido = true;
    if (anterior == 1 && proximo > anterior) {
      if ($("#pago_sumar_efector_id").select2('val') == "" || $("#pago_sumar_concepto_de_facturacion_id").select2('val') == "") {
        alert("Seleccione el efector y concepto a pagar");
        esValido = false;
      };
    };
    if (anterior == 2 && proximo > anterior) {
      if ($("#pago_sumar_expediente_sumar_ids").select2("val").length < 1) {
        alert("Debe seleccionar al menos a un expediente a pagar");
        esValido = false;
      };
    };
    if (anterior == 3 && proximo > anterior) {
      if ($("#pago_sumar_cuenta_bancaria_destino_id").select2("val") == "" || $("#pago_sumar_cuenta_bancaria_origen_id").select2("val") == "") {
        alert("Seleccione las cuentas de origen y destino de los fondos");
        esValido = false;
      };
    };

    return esValido;
  }

  

});

function generarResumen(obj, context) {
  if (context.fromStep == 3 && context.toStep == 4) {
    //Fields
    var efector = $("#pago_sumar_efector_id").select2("data");
    var concepto = $("#pago_sumar_concepto_de_facturacion_id").select2("data");
    var expedientes = $("#pago_sumar_expediente_sumar_ids").select2("data");
    var notas_de_debito = $("#pago_sumar_nota_de_debito_ids").select2("data");
    var cuenta_bancaria_origen = $("#pago_sumar_cuenta_bancaria_origen_id").select2("data");
    var cuenta_bancaria_destino = $("#pago_sumar_cuenta_bancaria_destino_id").select2("data");

    //divs
    var div_efector_y_concepto = $("#efector_y_concepto");
    var div_cuentas_bancarias = $("#cuentas_bancarias");
    var div_expedientes_y_nd = $("#expedientes_y_nd");

    var markup = "";
    var totalAPagar = 0.0;
    var totalDeDebitos = 0.0;

    markup += "<h3><b>" + efector.text + " - " + concepto.text + "</b></h3>";
    div_efector_y_concepto.html(markup);

    markup += "";

    markup += "</div>";
    markup += "<div style='margin-left:2em'>";
    markup += "  <b>Cuenta Bancaria Origen : </b>" + cuenta_bancaria_origen.text + "<br>";
    markup += "  <b>Cuenta Bancaria Destino : </b>" + cuenta_bancaria_destino.nombre + "<br>";
    markup += "</div>";

    div_cuentas_bancarias.html(markup);
    markup = "";

    markup += "<h4>Expedientes: </h4>";
    markup += "<div style='margin-left:2em'>";
    for (var i = expedientes.length - 1; i >= 0; i--) {
      markup += "<p><ul>";
      markup += "<li><b>Nº: </b>" + expedientes[i].numero + "</li> ";
      markup += "<li><b>Periodo: </b>" + expedientes[i].periodo + "</li> ";
      markup += "<li><b>Monto Aprobado: </b> $" + expedientes[i].monto_aprobado + "</li> ";
      markup += "</ul></p>";
      totalAPagar += parseFloat(expedientes[i].monto_aprobado);
    };
    markup += "</div>";

    if (notas_de_debito.length > 0) {
      markup += "<h4>Notas de Debito:</h4>";
      markup += "<div style='margin-left:2em'>";
      for (var i = notas_de_debito.length - 1; i >= 0; i--) {
        markup += "<p><ul>";
        markup += "<li><b>" + notas_de_debito[i].tipo_nombre + "</b></li> ";
        markup += "<li><b>Nº: </b>" + notas_de_debito[i].tipo_codigo + "-" + notas_de_debito[i].numero + "</li> ";
        markup += "<li><b>Monto Original: </b>  $ " + parseFloat(notas_de_debito[i].monto_original).toString() + "</li> ";
        markup += "<li><b>Monto Reservado: </b> $ " + parseFloat(notas_de_debito[i].monto_reservado).toString() + "</li> ";
        markup += "<li><b>Monto Remanente: </b> $ " + parseFloat(notas_de_debito[i].monto_remanente).toString() + "</li> ";
        markup += "<li><b>Monto Disponible: </b>$ " + parseFloat(notas_de_debito[i].monto_disponible).toString() + "</li> ";
        markup += "</ul></p>";
        totalDeDebitos += parseFloat(notas_de_debito[i].monto_disponible);
      };
    };

    totalAPagar -= totalDeDebitos;
    markup += "<h4>Total de Debitos: $ " + parseFloat(totalDeDebitos).toString() + "</h4>";

    div_expedientes_y_nd.html(markup);


    $("#totales").html("<h3>Total a pagar $ " + parseFloat(totalAPagar).toString() + "</h3>");
    $('#wizard').smartWizard('fixHeight');
  }

}

function enviarPago(objs, context) {
  $("#new_pago_sumar").submit();
}

function maquetaExpedientes(expediente) {
  var markup = "";
  markup += "<b>" + expediente.numero + " - " + expediente.periodo + "</b> ($ " + expediente.monto_aprobado + ")";

  return markup;
}

function maquetaExpedientesSeleccionados(expediente) {
  var markup = "";

  markup += "<b>" + expediente.numero + " - " + expediente.periodo + "</b> ($ " + expediente.monto_aprobado + ")";

  return markup;
}

function maquetaNotas(nd) {
  var markup = "";

  markup += "<b>" + nd.tipo_codigo + ": Nº " + nd.numero + " - " + "</b> ($ " + nd.monto_disponible + ")";

  return markup;
}

function maquetaNotasSeleccionadas(nd) {
  var markup = "";
  markup += "<b>" + nd.tipo_codigo + ": Nº " + nd.numero + " - " + "</b> ($ " + nd.monto_disponible + ")";

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