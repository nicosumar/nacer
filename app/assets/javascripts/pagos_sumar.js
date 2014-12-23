$(document).ready(function() {
  // Defino el wizzard
  $('#wizard').smartWizard({
    labelNext:'Siguiente', 
    labelPrevious:'Anterior',
    labelFinish:'Finalizar'  
  });

}); 

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
