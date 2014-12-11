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
  markup += "<div class='chkbox' id='tarjeta'>";
  markup += "  <table style='width: 100%'>";
  markup += "    <tbody><tr width='30%'>";
  markup += "      <td rowspan='3' style='border-bottom-style: solid;'>";
  markup += "        <h2>Expediente</h2>";
  markup += "        <br>";
  markup += "        <h2>"+expediente.numero+" Periodo "+expediente.periodo+"</h2>";
  markup += "      </td>";
/*
      <td>Informe de Liquidación Nº 7</td>
      <td>Aprobado $20000</td> 

<div class="chkbox" id="tarjeta">
  <table style="width: 100%">
    <tbody><tr width="30%">
      <td rowspan="3" style="border-bottom-style: solid;">
        <h2>Expediente</h2>
        <br>
        <h2>expediente.numero Periodo 2014-11</h2>
      </td>
      <td>Informe de Liquidación Nº 7</td>
      <td>Aprobado $20000</td>
    </tr>
    <tr width="50%">
      <td>Informe de Liquidación Nº 7 | 2013-08</td>
      <td>Aprobado $20000</td>
    </tr>
    <tr width="20%">
      <td colspan="2" style="text-align: right">TOTAL $20000</td>
    </tr>
  </tbody></table>
</div>

  
    var markup = "<table width='100%'><tr>";
    markup += "<td>Cod: <b>"+prestacion.codigo+"</b></td>"+"<td align='right'>Fecha:<b> "+prestacion.fecha+"</b></td>";
    markup += "</tr>";
    markup += "<tr>";
    markup += "<td>Desc:<b>"+prestacion.nombre+"</b></td><td align='right'>Monto<b> $"+prestacion.monto+"</b></td>";
    markup += "</tr>";
    markup += "</table>";
*/
    return markup;
}
function maquetaExpedientesSeleccionados(expediente) {
  var markup = "";
  markup += "<div class='chkbox' id='tarjeta'>";
  markup += "  <table style='width: 100%'>";
  markup += "    <tbody><tr width='30%'>";
  markup += "      <td rowspan='3' style='border-bottom-style: solid;'>";
  markup += "        <h2>Expediente</h2>";
  markup += "        <br>";
  markup += "        <h2>"+expediente.numero+" Periodo "+expediente.periodo+"</h2>";
  markup += "      </td>";

  return markup;
    //return "Cod:<b> "+prestacion.codigo+"</b> - Fecha:<b> "+prestacion.fecha+"</b>"+" - Monto:<b> $"+prestacion.monto+"</b>";
}
