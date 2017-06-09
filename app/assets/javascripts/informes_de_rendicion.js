var total;
var total_servicios;
var total_bienes_ctes;
var total_obras;
var total_bienes_capital;

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

	    var i=row.parentNode.parentNode.rowIndex;
	    document.getElementById('tabla_detalles').deleteRow(i);

	    updateRowIndex();
        updateTotales();

    }
}


function insertRow()
{
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

        total_servicios +=       (x.rows[i + 2].cells[7].innerHTML == '') ? 0 : parseInt(x.rows[i + 2].cells[7].innerHTML);
        total_obras +=           (x.rows[i + 2].cells[8].innerHTML == '') ? 0 : parseInt(x.rows[i + 2].cells[8].innerHTML);
        total_bienes_ctes +=     (x.rows[i + 2].cells[9].innerHTML == '') ? 0 : parseInt(x.rows[i + 2].cells[9].innerHTML);
        total_bienes_capital +=  (x.rows[i + 2].cells[10].innerHTML == '') ? 0 : parseInt(x.rows[i + 2].cells[10].innerHTML);

    }

    //alert("Servicios: " + total_servicios + " | Obras: " + total_obras + " | Ctes: " + total_bienes_ctes + " | Capital: " + total_bienes_capital);

    total = total_servicios + total_obras + total_bienes_capital + total_bienes_ctes;

    //alert("Total: " + total);

}

function saveNewInforme(){

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

    var informe_params = { "cantidad_detalles": length_detalles, "efector_id": efector_id, "mes_informe": mes_informe,
    "anio_informe": anio_informe, "dia_informe": dia_informe, "total_informe": total_informe, "numeros": numeros,
    "fechas_factura": fechas_factura, "numeros_factura": numeros_factura, "detalles": detalles, "cantidades": cantidades, 
    "numeros_cheque": numeros_cheque, "tipos_de_importe": tipos_de_importe, "importes": importes }

    //alert(JSON.stringify(informe_params));

    var url = '/informes_de_rendicion';

    $.ajax({
      type: "POST",
      url: url,
      data: informe_params,
      async: false
    });

}

function daysInMonth(iMonth, iYear)
{
    return 32 - new Date(iYear, iMonth - 1, 32).getDate();
}