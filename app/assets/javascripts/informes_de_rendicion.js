var total;
var total_servicios;
var total_bienes_ctes;
var total_obras;
var total_bienes_capital;

$(document).ready(function() {

    //info = -1 es index
    //info = 0 es new
    //info = 1 es show
    //info = 2 es edit

    //alert($('#info').attr('value'));

    if($('#info').attr('value') != "-1")
    {
        if($('#info').attr('value') != "0")
        {

            //alert("Estoy en edit o show");

            toggleDisplay(document.getElementById('detalle_form'), false);
            showInformes();

        }
        else {


            toggleDisplay(document.getElementById('new_detalle_button'), false);
            //alert("Estoy en new");

        }
    }
    else {

        if($('#info-permiso').attr('value') != 'puede_confirmar')
        {

            quitarConfirmar();

        }

        //alert ("Estoy en el index!");

    }

});

function addNewRow(){

    selected_row = -1;

    toggleDisplay(document.getElementById('new_detalle_button'), false);
    toggleDisplay(document.getElementById('detalle_form'), true);

}

function toggleDisplay(element, show) {

    if(element){

        if (show) {
            element.style.display = 'block';
        } else {
            element.style.display = 'none';
        }

    }
} 

function deleteRow(row)
{

	var x=document.getElementById('tabla_detalles');
    var last_index = x.rows.length - 1;

    if(last_index == 2){

	    var new_row = x.rows[last_index];
	    new_row.cells[0].innerHTML = last_index - 1;

	    for(i = 1; i < new_row.cells.length - 1; i++){

	    	if(i == 4){
    			new_row.cells[i].innerHTML = 'SIN MOVIMIENTOS';
	    	}
	    	else {
    			new_row.cells[i].innerHTML = '';
	    	}

    	}	

    }
    else {

	    var i = row.parentNode.parentNode.rowIndex;
	    document.getElementById('tabla_detalles').deleteRow(i);

	    updateRowIndex();

    }

    updateTotales();
    
}

function insertRow()
{

    if(hasWarnings()){

        alert("Por favor, controla que todos los campos estén completos y los datos ingresados sean correctos.")
        return;

    }

    var x = document.getElementById('tabla_detalles');

    var indices = [
    	{tableId: "1", elementId: "form-1", tipo: "basico"},
    	{tableId: "2", elementId: "detalle_informe_de_rendicion_fecha_factura_", tipo: "fecha"},
    	{tableId: "3", elementId: "form-3", tipo: "basico"},
    	{tableId: "4", elementId: "form-4", tipo: "basico"},
    	{tableId: "5", elementId: "form-5", tipo: "basico"},
    	{tableId: "6", elementId: "form-6", tipo: "basico"},
    	{tableId: "7", elementId: "form-7", tipo: "selector_importe"},
    	{tableId: "8", elementId: "form-8", tipo: "valor_importe"},
    ]

    //Primero necesito controlar si la primera fila que hay es la de SIN MOVIMIENTOS. En ese
    //caso debo actualizar esa misma fila.
    //En otro caso, debo crear una nueva.

    var last_index = x.rows.length - 1;
    var last_row = x.rows[last_index];
    
    var new_row;

	if(last_row.cells[4].innerHTML == 'SIN MOVIMIENTOS')
	{

		new_row = last_row;

	}
    else {

		new_row = x.rows[last_index].cloneNode(true); 
    	new_row.cells[0].innerHTML = last_index;

    }

    //Y acá cargo los datos nuevos

    //1 es la primera columna de la tabla, xq la 0 es el index
    //7 es el lugar donde el formulario llega a el tipo de importe
    //ahi tengo que chequear el tipo y en funcion de eso ver cual completo
    
    for(i = 0; i < indices.length; i++){
    	
    	var indice = indices[i];

    	switch(indice.tipo){


    		case 'basico':
    		
	    		new_row.cells[indice.tableId].innerHTML = document.getElementById(indice.elementId).value;
	    		document.getElementById(indice.elementId).value = '';

    		break;

    		case 'fecha':

    			var fecha_value = '';

    			for(j = 3; j > 0; j--){

    				fecha_value += document.getElementById(indice.elementId + j + "i").value
    				fecha_value += (j == 1) ? '' : '/';

    			}

    			new_row.cells[indice.tableId].innerHTML = fecha_value;

    		break;

    		case 'valor_importe':

    			new_row.cells[7].innerHTML = '';
	    		new_row.cells[8].innerHTML = '';
	    		new_row.cells[9].innerHTML = '';
	    		new_row.cells[10].innerHTML = '';

    			switch(document.getElementById(indices[i-1].elementId).value){

	    			case 'A':
			    		new_row.cells[7].innerHTML = document.getElementById(indice.elementId).value;

	    			break;
	    			case 'B':

	    				new_row.cells[8].innerHTML = document.getElementById(indice.elementId).value;

	    			break;
	    			case 'C':

	    				new_row.cells[9].innerHTML = document.getElementById(indice.elementId).value;

	    			break;
	    			case 'D':

	    				new_row.cells[10].innerHTML = document.getElementById(indice.elementId).value;

	    			break;

	    		}

    			document.getElementById(indice.elementId).value = 'A';
    			document.getElementById(indice.elementId).value = '';

    		break;

    	}

    }

    //Finalmente la agrego a la tabla
    x.appendChild( new_row );
    updateTotales();

}

function updateRowIndex(){

	var x = document.getElementById('tabla_detalles');
    var last_index = x.rows.length;

	for(i = 2; i < last_index; i++){

    	x.rows[i].cells[0].innerHTML = i - 1;
    
    }

}

function updateTotales(){

    //Tengo que ir mostrando los totales por tipo de importe y el total final

    var x = document.getElementById('tabla_detalles');
    var length_detalles = x.rows.length - 2; 

    total = 0;
    total_servicios = 0;
    total_bienes_ctes = 0;
    total_obras = 0;
    total_bienes_capital = 0;

    for(i = 0; i < length_detalles; i++){

        total_servicios +=       (x.rows[i + 2].cells[7].innerHTML == '') ? 0 : parseFloat(x.rows[i + 2].cells[7].innerHTML);
        total_obras +=           (x.rows[i + 2].cells[8].innerHTML == '') ? 0 : parseFloat(x.rows[i + 2].cells[8].innerHTML);
        total_bienes_ctes +=     (x.rows[i + 2].cells[9].innerHTML == '') ? 0 : parseFloat(x.rows[i + 2].cells[9].innerHTML);
        total_bienes_capital +=  (x.rows[i + 2].cells[10].innerHTML == '') ? 0 : parseFloat(x.rows[i + 2].cells[10].innerHTML);

    }

    //alert("Servicios: " + total_servicios + " | Obras: " + total_obras + " | Ctes: " + total_bienes_ctes + " | Capital: " + total_bienes_capital);

    total = total_servicios + total_obras + total_bienes_capital + total_bienes_ctes;

    //alert("Total: " + total);

    var y = document.getElementById('tabla_totales');

    y.rows[1].cells[0].innerHTML = total_servicios;
    y.rows[1].cells[1].innerHTML = total_obras;
    y.rows[1].cells[2].innerHTML = total_bienes_ctes;
    y.rows[1].cells[3].innerHTML = total_bienes_capital;
    y.rows[1].cells[4].innerHTML = total;

}

function saveInforme(is_new){

    //en esta funcion tengo que crear un nuevo informe_de_rendicion (creo que en realidad uso el que cree en el new del controlador)
    //y luego crear uno por uno los detalles usando los valores correspondientes de las tablas, posteriormente asociandolos al informe_de_rendicion
    //creado
    //tambien tengo que asociarle el tipo_de_importe que corresponda
    //y enviar los post correspondientes

    /*

    La idea seria pasar los datos que corresponden al informe (ID DEL EFECTOR!!!, fecha y total) y los datos de todos los detalles  
    (numero, fecha_factura, numero_factura, detalle, cantidad, numero_cheque || y tambien tengo que 
    indicar en algun parametro el tipo de importe para que despues sepa cual tengo que asociar)

    */

    var x = document.getElementById('tabla_detalles');
    var length_detalles = x.rows.length - 2; //esto me da la cantidad de filas que tienen datos que tengo que guardar

    //INFORME DE RENDICION

    var efector_id = $('#id_efector').attr('value');

    var mes_informe = document.getElementById('date_month').value;
    var anio_informe = document.getElementById('date_year').value;
    //los informes se hacen AL ULTIMO DÍA del mes que se indica
    var dia_informe = daysInMonth(mes_informe, anio_informe);

    var total_informe = total;

    //DETALLES

    var numeros = [];
    var fechas_factura = [];
    var numeros_factura = [];
    var detalles = [];
    var cantidades = []; 
    var numeros_cheque = []; 
    var tipos_de_importe = [];
    var importes = [];

    for(i = 0; i < length_detalles; i++){

        numeros[i] =            x.rows[i + 2].cells[1].innerHTML;
        fechas_factura[i] =      x.rows[i + 2].cells[2].innerHTML;
        numeros_factura[i] =     x.rows[i + 2].cells[3].innerHTML;
        detalles[i] =            x.rows[i + 2].cells[4].innerHTML;
        cantidades[i] =           x.rows[i + 2].cells[5].innerHTML;
        numeros_cheque[i] =      x.rows[i + 2].cells[6].innerHTML;

        if(x.rows[i + 2].cells[7].innerHTML != '') //SERVICIOS
        {

            tipos_de_importe[i] =    "1";
            importes[i] =            x.rows[i + 2].cells[7].innerHTML;

        }
        else if (x.rows[i + 2].cells[8].innerHTML != '') //OBRAS
        {

            tipos_de_importe[i] =    "2";
            importes[i] =            x.rows[i + 2].cells[8].innerHTML;

        }
        else if (x.rows[i + 2].cells[9].innerHTML != '') //BIENES CORRIENTES
        {

            tipos_de_importe[i] =    "3";
            importes[i] =            x.rows[i + 2].cells[9].innerHTML;

        }
        else if (x.rows[i + 2].cells[10].innerHTML != '') //BIENES DE CAPITAL
        {

            tipos_de_importe[i] =    "4";
            importes[i] =            x.rows[i + 2].cells[10].innerHTML;

        }

       /* alert("Detalle n°" + i
             + "\nNumero: " + numeros[i]
             + "\nFecha Factura: " + fechas_factura[i]
             + "\nNumero Factura: " + numeros_factura[i]
             + "\nDetalle: " + detalles[i]
             + "\nCantidad: " + cantidades[i]
             + "\nNumero de Cheque: " + numeros_cheque[i]
             + "\nTipo de Importe: " + tipos_de_importe[i]
             + "\nImporte: " + importes[i]);*/

    }


    var length_detalles = x.rows.length - 2; //esto me da la cantidad de filas que tienen datos que tengo que guardar

    //INFORME DE RENDICION

    var efector_id = $('#id_efector').attr('value');

    var mes_informe = document.getElementById('date_month').value;
    var anio_informe = document.getElementById('date_year').value;
    //los informes se hacen AL ULTIMO DÍA del mes que se indica
    var dia_informe = daysInMonth(mes_informe, anio_informe);

    var total_informe = total;

    //DETALLES

    var informe_params = {"cantidad_detalles": length_detalles, "efector_id": efector_id, "mes_informe": mes_informe,
    "anio_informe": anio_informe, "dia_informe": dia_informe, "total_informe": total_informe, "numeros": numeros,
    "fechas_factura": fechas_factura, "numeros_factura": numeros_factura, "detalles": detalles, "cantidades": cantidades, 
    "numeros_cheque": numeros_cheque, "tipos_de_importe": tipos_de_importe, "importes": importes }

    //alert(JSON.stringify(informe_params));

    if(is_new)
    {

        //CREO UN NUEVO REGISTRO

        var url = '/informes_de_rendicion';

        $.post(url, informe_params, function(params) {

          window.location.replace(params.redirect_to + "?result=ok")

        })
          .fail(function(params) {

            alert( "La operación ha fallado. Por favor, revise los datos e intente nuevamente, o contactesé con el administrador." );
          
          });


    }
    else {

        //EDITO UN REGISTRO EXISTENTE

        var url = window.location.href + "?operacion=edit";

        $.ajax({
           url: url,
           type: 'PUT',
           data: informe_params,
           success: function(params) {
             window.location.replace(params.redirect_to + "?result=ok")
           },
           fail: function(params){
            alert( "La operación ha fallado. Por favor, revise los datos e intente nuevamente, o contactesé con el administrador." );
           }
        });

    }

}

function daysInMonth(iMonth, iYear)
{
    return 32 - new Date(iYear, iMonth - 1, 32).getDate();
}

function showMessage(content, advertencia_number, type){

    var is_valid = true;

    if(content.value != "")
    {

        if(!$.isNumeric(content.value)) //No es un número
        {

            if(type == "int" || type == "float")
            {

                is_valid = false;
                document.getElementById("advertencia-" + advertencia_number).innerHTML = "Este campo acepta sólo números mayores que cero."

            }

        }
        else //Es un número
        {

            if(type == "int")
            {

                if(!isInt(content.value))
                {

                    is_valid = false;
                    document.getElementById("advertencia-" + advertencia_number).innerHTML = "Este campo debe contener sólo números ENTEROS mayores que cero."

                }

            }
            else if(type == "text") 
            {

                is_valid = false;
                document.getElementById("advertencia-" + advertencia_number).innerHTML = "Este campo debe contener letras."

            }

        }

    }
    else {

        is_valid = false;
        document.getElementById("advertencia-" + advertencia_number).innerHTML = "Este campo " 
        + ((type == "text") ? "debe contener letras." : ("debe contener sólo números" + ((type == "int") ? " ENTEROS mayores que cero" : " mayores que cero")));

    }

    if(is_valid){

        document.getElementById("advertencia-" + advertencia_number).innerHTML = ""

    }

}

function hasWarnings(){

    var has_warnings = false;

    for(i = 1; i < 9; i++){

        if(document.getElementById("form-" + i) && document.getElementById("form-" + i).value == ""){

            has_warnings = true;
            break;

        }

    }

    if(has_warnings){

        return has_warnings;

    }
        
    for(i = 1; i < 9; i++){

        if(document.getElementById("advertencia-" + i).innerHTML != ""){

            has_warnings = true;
            break;

        }

    }

    return has_warnings;

}

function isNumber(content) {
    

    var reg = new RegExp("^[-]?[0-9]+[\.]?[0-9]+$");
    return reg.test(content);

 }

function isInt(n) {

   return n % 1 === 0;

}

function checkSpecialChars(content){

    var iChars = "~`!#$%^&*+=-[]\\\';,/{}|\":<>?";

    for (var i = 0; i < content.length; i++)
    {
      if (iChars.indexOf(content.charAt(i)) != -1)
      {
         return false;
      }
    }

    return true;

}

function showInformes(){

    var informe_json = JSON.parse($('#informe_de_rendicion').attr('value'));

    var fecha_partes = informe_json.fecha_informe.split('/');

    $('#anio_informe').value = fecha_partes[0];
    $('#mes_informe').value = fecha_partes[1];

    var detalles_informe_json = JSON.parse($('#detalles_informe_de_rendicion').attr('value'));

    var x = document.getElementById('tabla_detalles');

    var last_index = x.rows.length - 1;
    var new_row = x.rows[last_index];

    for(i = 0; i < detalles_informe_json.length; i++){

        if(i > 0)
        {

            new_row = x.rows[last_index].cloneNode(true)
            new_row.cells[0].innerHTML = last_index;
            last_index++; 

            new_row.cells[7].innerHTML = '';
            new_row.cells[8].innerHTML = '';
            new_row.cells[9].innerHTML = '';
            new_row.cells[10].innerHTML = '';

        }

        new_row.cells[1].innerHTML = detalles_informe_json[i].numero;

        if(detalles_informe_json[i].fecha_factura == null)
        {

            new_row.cells[2].innerHTML = '';

        }
        else {

            var fecha = detalles_informe_json[i].fecha_factura.split("-");
            new_row.cells[2].innerHTML = fecha[2] + "-" + fecha[1] + "-" + fecha[0];

        }

        new_row.cells[3].innerHTML = detalles_informe_json[i].numero_factura;
        new_row.cells[4].innerHTML = detalles_informe_json[i].detalle;
        new_row.cells[5].innerHTML = detalles_informe_json[i].cantidad;
        new_row.cells[6].innerHTML = detalles_informe_json[i].numero_cheque;

        new_row.cells[6 + detalles_informe_json[i].tipo_de_importe_id].innerHTML 
            = detalles_informe_json[i].importe;
            
        //Finalmente la agrego a la tabla
        x.appendChild( new_row );

    }
    
    updateTotales();

}

var selected_row;

function updateRow()
{

    if(selected_row == -1) //en el edit, agrego una nueva row
    {

        insertRow();
        return;

    }


    if(hasWarnings()){

        alert("Por favor, controla que todos los campos estén completos y los datos ingresados sean correctos.")
        return;

    }

    var indices = [
        {tableId: "1", elementId: "form-1", tipo: "basico"},
        {tableId: "2", elementId: "detalle_informe_de_rendicion_fecha_factura_", tipo: "fecha"},
        {tableId: "3", elementId: "form-3", tipo: "basico"},
        {tableId: "4", elementId: "form-4", tipo: "basico"},
        {tableId: "5", elementId: "form-5", tipo: "basico"},
        {tableId: "6", elementId: "form-6", tipo: "basico"},
        {tableId: "7", elementId: "form-7", tipo: "selector_importe"},
        {tableId: "8", elementId: "form-8", tipo: "valor_importe"},
    ]
    
    for(i = 0; i < indices.length; i++){
        
        var indice = indices[i];

        switch(indice.tipo){


            case 'basico':
            
                selected_row.cells[indice.tableId].innerHTML = document.getElementById(indice.elementId).value;
                document.getElementById(indice.elementId).value = '';

            break;

            case 'fecha':

                var fecha_value = '';

                for(j = 3; j > 0; j--){

                    fecha_value += document.getElementById(indice.elementId + j + "i").value
                    fecha_value += (j == 1) ? '' : '-';

                }

                selected_row.cells[indice.tableId].innerHTML = fecha_value;

            break;

            case 'valor_importe':

                selected_row.cells[7].innerHTML = '';
                selected_row.cells[8].innerHTML = '';
                selected_row.cells[9].innerHTML = '';
                selected_row.cells[10].innerHTML = '';

                switch(document.getElementById(indices[i-1].elementId).value){

                    case 'A':
                        selected_row.cells[7].innerHTML = document.getElementById(indice.elementId).value;

                    break;
                    case 'B':

                        selected_row.cells[8].innerHTML = document.getElementById(indice.elementId).value;

                    break;
                    case 'C':

                        selected_row.cells[9].innerHTML = document.getElementById(indice.elementId).value;

                    break;
                    case 'D':

                        selected_row.cells[10].innerHTML = document.getElementById(indice.elementId).value;

                    break;

                }

                document.getElementById(indice.elementId).value = 'A';
                document.getElementById(indice.elementId).value = '';

            break;

        }

    }

    toggleDisplay(document.getElementById('new_detalle_button'), true);
    toggleDisplay(document.getElementById('detalle_form'), false);

    updateTotales();

}

function editRow(row_to_edit)
{

    var indices = [
        {tableId: "1", elementId: "form-1", tipo: "basico"},
        {tableId: "2", elementId: "detalle_informe_de_rendicion_fecha_factura_", tipo: "fecha"},
        {tableId: "3", elementId: "form-3", tipo: "basico"},
        {tableId: "4", elementId: "form-4", tipo: "basico"},
        {tableId: "5", elementId: "form-5", tipo: "basico"},
        {tableId: "6", elementId: "form-6", tipo: "basico"},
        {tableId: "7", elementId: "form-7", tipo: "selector_importe"},
        {tableId: "8", elementId: "form-8", tipo: "valor_importe"},
    ]

    var i = row_to_edit.parentNode.parentNode.rowIndex;
    selected_row = document.getElementById('tabla_detalles').rows[i];
    
    for(i = 0; i < indices.length; i++){
        
        var indice = indices[i];

        switch(indice.tipo){


            case 'basico':
            
                document.getElementById(indice.elementId).value = selected_row.cells[indice.tableId].innerHTML;

            break;

            case 'fecha':

                var fecha_value = selected_row.cells[indice.tableId].innerHTML.split('-');

                document.getElementById(indice.elementId + "1i").value = parseInt(fecha_value[2]);
                document.getElementById(indice.elementId + "2i").value = parseInt(fecha_value[1]);
                document.getElementById(indice.elementId + "3i").value = parseInt(fecha_value[0]);

            break;

            case 'valor_importe':

                if(selected_row.cells[7].innerHTML != '')
                {

                    //A
                    document.getElementById(indices[i-1].elementId).value = "A";
                    document.getElementById(indice.elementId).value = selected_row.cells[7].innerHTML;


                }
                else if (selected_row.cells[8].innerHTML != '')
                {

                    //B
                    document.getElementById(indices[i-1].elementId).value = "B";
                    document.getElementById(indice.elementId).value = selected_row.cells[8].innerHTML;

                }
                else if (selected_row.cells[9].innerHTML != '')
                {

                    //C
                    document.getElementById(indices[i-1].elementId).value = "C";
                    document.getElementById(indice.elementId).value = selected_row.cells[9].innerHTML;

                }
                else {

                    //D
                    document.getElementById(indices[i-1].elementId).value = "D";
                    document.getElementById(indice.elementId).value = selected_row.cells[10].innerHTML;
                }

            break;

        }

    }

    toggleDisplay(document.getElementById('new_detalle_button'), false);
    toggleDisplay(document.getElementById('detalle_form'), true);

}

function quitarConfirmar(){

    var child = document.getElementsByClassName("confirmar_button");
    
    var length = child.length;

    for (i = 0; i < length; i++) {

        child[i].innerHTML = "NO CERRADO";
        //child[i].parentNode.removeChild(child[i]);

    } 

}

