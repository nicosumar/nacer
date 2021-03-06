var total;
var total_servicios;
var total_bienes_ctes;
var total_obras;
var total_bienes_capital;

var dont_show_clasificacion = false;

$(document).ready(function() {

    //info = -1 es index
    //info = 0 es new
    //info = 1 es show
    //info = 2 es edit

    //alert($('#info').attr('value'));

    if($('#info_op').attr('value') != -1)
    {

        //Si no es el index, en todos los casos oculto el form del detalle. Solo lo muestro cuando apreto el boton para agregar uno
        toggleDisplay(document.getElementById('detalle_form'), false);

        //si estoy en el show no quiero actualizar los campos editables del tipo de gasto
        if($('#info_op').attr('value') != 1)
        {

            if($('#permiso').attr('value') == "no_puede_clasificar"){

                dont_show_clasificacion = true;
                clase_de_gasto_selected = 1;
                tipo_de_gasto_selected = 1;
                toggleDisplay(document.getElementById('clasificacion_gasto'), false);

            }

            updateClaseDeGasto();

        }
        else {

            if($('#permiso').attr('value') == "no_puede_clasificar"){

                dont_show_clasificacion = true;

            }

            //Si estoy en el SHOW tengo que ocultar el boton para agregar nuevo detalle
            toggleDisplay(document.getElementById('new_detalle_button'), false);

        }

        if($('#info_op').attr('value') != 0)
        {

            //SI ESTOY EN EL SHOW O EN EL EDIT TENGO QUE MOSTRAR LOS INFORMES ANTERIORES
            showInformes();

        }

    }
    else {

        if($('#info-permiso').attr('value') != 'puede_confirmar')
        {

            quitarRechazar();
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

function cleanForm(){

    var indices = [
        {tableId: "1", elementId: "form-1", tipo: "basico"},
        {tableId: "2", elementId: "detalle_informe_de_rendicion_fecha_factura_", tipo: "fecha"},
        {tableId: "3", elementId: "form-3", tipo: "basico"},
        {tableId: "4", elementId: "form-4", tipo: "basico"},
        {tableId: "5", elementId: "form-5", tipo: "basico"},
        {tableId: "6", elementId: "form-6", tipo: "basico"},
        {tableId: "7", elementId: "form-7", tipo: "selector_importe"},
        {tableId: "8", elementId: "form-8", tipo: "valor_importe"},
        {tableId: "9", elementId: "", tipo: "tipo_de_gasto"},
        {tableId: "10", elementId: "form-9", tipo: "selector_cuenta"}
    ]

    for(i = 0; i < indices.length; i++){
        
        var indice = indices[i];

        switch(indice.tipo){


            case 'basico':
            
                document.getElementById(indice.elementId).value = '';

            break;

            case 'fecha':

            break;

            case 'valor_importe':

                document.getElementById(indice.elementId).value = 'A';
                document.getElementById(indice.elementId).value = '';

            break;

            case 'selector_cuenta':

                document.getElementById(indice.elementId).value = '1';

            break;

        }

    }

    selected_row = -1;
    toggleDisplay(document.getElementById('new_detalle_button'), true);
    toggleDisplay(document.getElementById('detalle_form'), false);

}

function deleteRow(row)
{

    if(selected_row != -1){

        cleanForm();

    }

	var x=document.getElementById('tabla_detalles');
    var last_index = x.rows.length - 1;

    if(last_index == 2){

	    var new_row = x.rows[last_index];
	    new_row.cells[0].innerHTML = last_index - 1;

	    for(i = 1; i < new_row.cells.length - 1; i++){

	    	if(i == 4){
    			new_row.cells[i].innerHTML = 'SIN MOVIMIENTOS';
                disableButtons();
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
        {tableId: "9", elementId: "", tipo: "tipo_de_gasto"},
        {tableId: "10", elementId: "form-9", tipo: "selector_cuenta"}
    ]

    //Primero necesito controlar si la primera fila que hay es la de SIN MOVIMIENTOS. En ese
    //caso debo actualizar esa misma fila.
    //En otro caso, debo crear una nueva.

    var last_index = x.rows.length - 1;
    var last_row = x.rows[last_index];
    
    var new_row;

	if(last_row.cells[4].innerHTML == 'SIN MOVIMIENTOS')
	{

        enableButtons();
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
    				fecha_value += (j == 1) ? '' : '-';

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
                        new_row.cells[7].innerHTML += (dont_show_clasificacion) ? "" : " (" + clase_de_gasto_selected + "." + tipo_de_gasto_selected + ")";

	    			break;
	    			case 'B':

	    				new_row.cells[8].innerHTML = document.getElementById(indice.elementId).value;
                        new_row.cells[8].innerHTML += (dont_show_clasificacion) ? "" : " (" + clase_de_gasto_selected + "." + tipo_de_gasto_selected + ")";

	    			break;
	    			case 'C':

	    				new_row.cells[9].innerHTML = document.getElementById(indice.elementId).value;
                        new_row.cells[9].innerHTML += (dont_show_clasificacion) ? "" : " (" + clase_de_gasto_selected + "." + tipo_de_gasto_selected + ")";

	    			break;
	    			case 'D':

	    				new_row.cells[10].innerHTML = document.getElementById(indice.elementId).value;
                        new_row.cells[10].innerHTML += (dont_show_clasificacion) ? "" : " (" + clase_de_gasto_selected + "." + tipo_de_gasto_selected + ")";

	    			break;

	    		}

    			document.getElementById(indice.elementId).value = 'A';
    			document.getElementById(indice.elementId).value = '';

    		break;

            case 'selector_cuenta':

                new_row.cells[11].innerHTML = (document.getElementById(indices[i].elementId) != null) ? document.getElementById(indices[i].elementId).value : '1';

            break;

    	}

    }

    //Finalmente la agrego a la tabla
    x.appendChild( new_row );
    
    toggleDisplay(document.getElementById('new_detalle_button'), true);
    toggleDisplay(document.getElementById('detalle_form'), false);

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
    var clases_de_gasto = [];
    var tipos_de_gasto = [];
    var cuentas = [];

    for(i = 0; i < length_detalles; i++){

        numeros[i] =            x.rows[i + 2].cells[1].innerHTML;
        fechas_factura[i] =      x.rows[i + 2].cells[2].innerHTML;
        numeros_factura[i] =     x.rows[i + 2].cells[3].innerHTML;
        detalles[i] =            x.rows[i + 2].cells[4].innerHTML;
        cantidades[i] =           x.rows[i + 2].cells[5].innerHTML;
        numeros_cheque[i] =      x.rows[i + 2].cells[6].innerHTML;
        cuentas[i] = x.rows[i + 2].cells[11].innerHTML;

        if(dont_show_clasificacion){

            clases_de_gasto[i] = 1;
            tipos_de_gasto[i] = 1;

        }

        if(x.rows[i + 2].cells[7].innerHTML != '') //SERVICIOS
        {

            tipos_de_importe[i] =    "1";
            importes[i] =            x.rows[i + 2].cells[7].innerHTML;

            if(!dont_show_clasificacion){

                clases_de_gasto[i] = get_clase_de_gasto(importes[i]);
                tipos_de_gasto[i] = get_tipo_de_gasto(importes[i]);

                importes[i] = importes[i].split("(")[0];

            }

        }
        else if (x.rows[i + 2].cells[8].innerHTML != '') //OBRAS
        {

            tipos_de_importe[i] =    "2";
            importes[i] =            x.rows[i + 2].cells[8].innerHTML;

            if(!dont_show_clasificacion){

                clases_de_gasto[i] = get_clase_de_gasto(importes[i]);
                tipos_de_gasto[i] = get_tipo_de_gasto(importes[i]);

                importes[i] = importes[i].split("(")[0];

            }

        }
        else if (x.rows[i + 2].cells[9].innerHTML != '') //BIENES CORRIENTES
        {

            tipos_de_importe[i] =    "3";
            importes[i] =            x.rows[i + 2].cells[9].innerHTML;

            if(!dont_show_clasificacion){

                clases_de_gasto[i] = get_clase_de_gasto(importes[i]);
                tipos_de_gasto[i] = get_tipo_de_gasto(importes[i]);

                importes[i] = importes[i].split("(")[0];

            }

        }
        else if (x.rows[i + 2].cells[10].innerHTML != '') //BIENES DE CAPITAL
        {

            tipos_de_importe[i] =    "4";
            importes[i] =            x.rows[i + 2].cells[10].innerHTML;

            if(!dont_show_clasificacion){

                clases_de_gasto[i] = get_clase_de_gasto(importes[i]);
                tipos_de_gasto[i] = get_tipo_de_gasto(importes[i]);

                importes[i] = importes[i].split("(")[0];

            }

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
    "numeros_cheque": numeros_cheque, "tipos_de_importe": tipos_de_importe, "importes": importes, "clases_de_gasto": clases_de_gasto, 
    "tipos_de_gasto": tipos_de_gasto, "cuentas": cuentas}

    //alert(JSON.stringify(informe_params));

    if(is_new)
    {

        //CREO UN NUEVO REGISTRO

        var url = '/informes_de_rendicion';

        $.ajax({
           url: url,
           type: 'POST',
           data: informe_params,
           success: function(params){

                alert(params.titulo);

                if(params.url != ""){

                    window.location.replace(params.url);

                }

           },
           fail: function(params){
            alert( "La operación ha fallado. Por favor, revise los datos e intente nuevamente, o contactesé con el administrador." );
           }
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

                alert(params.titulo);

                if(params.url != ""){

                    window.location.replace(params.url);

                }

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
                else {

                    if(advertencia_number == 6)
                    {

                        if(content.value.length != 5)
                        {

                            is_valid = false;
                            document.getElementById("advertencia-" + advertencia_number).innerHTML = "Deben ser ingresados los últimos 5 dígitos del número de cheque."

                        }
                        else {

                            var numeros_cheque = JSON.parse($('#numeros_existentes_cheque').attr('value'));
                            
                            for(i = 0; i < numeros_cheque.length; i++)
                            {

                                if(content.value == parseInt(numeros_cheque[i])){

                                    is_valid = false;
                                    document.getElementById("advertencia-" + advertencia_number).innerHTML = "Este número de cheque ha sido utilizado anteriormente. Recuerde que no puede repetirse."
                                    break;

                                }

                            }

                        }

                    }

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

    if($('#info_op').attr('value') == 2 && informe_json.fecha_informe != null){

        //SOLO SI ESTOY EN EL EDIT HAGO ESTO, EN EL SHOW NO MUESTRO EL SELECTOR DE LA FECHA

        var fecha_partes = informe_json.fecha_informe.split('-');

        document.getElementById('date_year').value = parseInt(fecha_partes[0]);
        document.getElementById('date_month').value = parseInt(fecha_partes[1]);

    }

    var detalles_informe_json = JSON.parse($('#detalles_informe_de_rendicion').attr('value'));
    var tipos_de_gasto_por_detalle = JSON.parse($('#tipos_de_gasto_por_detalle').attr('value'));

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
        new_row.cells[11].innerHTML = detalles_informe_json[i].cuenta;

        if(!dont_show_clasificacion){

            var tipo_de_gasto = tipos_de_gasto_por_detalle[i].tipo;

            if(tipo_de_gasto != ""){

                new_row.cells[6 + detalles_informe_json[i].tipo_de_importe_id].innerHTML 
                    = detalles_informe_json[i].importe + " (" + tipo_de_gasto + ")";

            }

        }   
        else{

            new_row.cells[6 + detalles_informe_json[i].tipo_de_importe_id].innerHTML = detalles_informe_json[i].importe;

        }

        //Finalmente la agrego a la tabla
        x.appendChild( new_row );

    }

    enableButtons();

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
        {tableId: "9", elementId: "", tipo: "clasificacion_gasto"},
        {tableId: "10", elementId: "form-9", tipo: "selector_cuenta"}
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
                        selected_row.cells[7].innerHTML += (dont_show_clasificacion) ? "" : " (" + clase_de_gasto_selected + "." + tipo_de_gasto_selected + ")";

                    break;
                    case 'B':

                        selected_row.cells[8].innerHTML = document.getElementById(indice.elementId).value;
                        selected_row.cells[8].innerHTML += (dont_show_clasificacion) ? "" : " (" + clase_de_gasto_selected + "." + tipo_de_gasto_selected + ")";

                    break;
                    case 'C':

                        selected_row.cells[9].innerHTML = document.getElementById(indice.elementId).value;
                        selected_row.cells[9].innerHTML += (dont_show_clasificacion) ? "" : " (" + clase_de_gasto_selected + "." + tipo_de_gasto_selected + ")";

                    break;
                    case 'D':

                        selected_row.cells[10].innerHTML = document.getElementById(indice.elementId).value;
                        selected_row.cells[10].innerHTML += (dont_show_clasificacion) ? "" : " (" + clase_de_gasto_selected + "." + tipo_de_gasto_selected + ")";

                    break;

                }

                document.getElementById(indice.elementId).value = 'A';
                document.getElementById(indice.elementId).value = '';

            break;

            case 'selector_cuenta':

                selected_row.cells[11].innerHTML = (document.getElementById(indices[i].elementId) != null) ? document.getElementById(indices[i].elementId).value : '1';

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
        {tableId: "9", elementId: "", tipo: "clasificacion_gasto"},
        {tableId: "10", elementId: "form-9", tipo: "selector_cuenta"}
    ]

    var index = row_to_edit.parentNode.parentNode.rowIndex;
    selected_row = document.getElementById('tabla_detalles').rows[index];
    
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
                    document.getElementById(indice.elementId).value = 
                        (dont_show_clasificacion) ? parseInt(selected_row.cells[7].innerHTML) 
                                                    : parseInt(selected_row.cells[7].innerHTML.split('(')[0]);

                    show_tipo_in_form(selected_row.cells[7].innerHTML);

                }
                else if (selected_row.cells[8].innerHTML != '')
                {

                    //B
                    document.getElementById(indices[i-1].elementId).value = "B";
                    document.getElementById(indice.elementId).value = 
                        (dont_show_clasificacion) ? parseInt(selected_row.cells[8].innerHTML) 
                                                    : parseInt(selected_row.cells[8].innerHTML.split('(')[0]);

                    show_tipo_in_form(selected_row.cells[8].innerHTML);

                }
                else if (selected_row.cells[9].innerHTML != '')
                {

                    //C
                    document.getElementById(indices[i-1].elementId).value = "C";
                    document.getElementById(indice.elementId).value = 
                        (dont_show_clasificacion) ? parseInt(selected_row.cells[9].innerHTML) 
                                                    : parseInt(selected_row.cells[9].innerHTML.split('(')[0]);

                    show_tipo_in_form(selected_row.cells[9].innerHTML);

                }
                else {

                    //D
                    document.getElementById(indices[i-1].elementId).value = "D";
                    document.getElementById(indice.elementId).value = 
                        (dont_show_clasificacion) ? parseInt(selected_row.cells[10].innerHTML) 
                                                    : parseInt(selected_row.cells[10].innerHTML.split('(')[0]);

                    show_tipo_in_form(selected_row.cells[10].innerHTML);
                }

            break;

            case 'selector_cuenta':

                document.getElementById(indices[i].elementId).value = selected_row.cells[11].innerHTML;

            break;

        }

    }

    toggleDisplay(document.getElementById('new_detalle_button'), false);
    toggleDisplay(document.getElementById('detalle_form'), true);

}

function get_clase_de_gasto(value){

    var temp = value.split('('); //numero(a.b) => [numero, a.b)]
    temp = temp[1].split(')'); //a.b) => [a.b]
    temp = temp[0].split('.'); //a.b => [a,b]
    
    return parseInt(temp[0]);

}

function get_tipo_de_gasto(value){

    var temp = value.split('('); //numero(a.b) => [numero, a.b)]
    temp = temp[1].split(')'); //a.b) => [a.b]
    temp = temp[0].split('.'); //a.b => [a,b]

    return parseInt(temp[1]);

}

function show_tipo_in_form(value){

    if(dont_show_clasificacion){

        return;

    }

    var temp = value.split('('); //numero(a.b) => [numero, a.b)]
    temp = temp[1].split(')'); //a.b) => [a.b]
    temp = temp[0].split('.'); //a.b => [a,b]

    var select_base = $("#clase_de_gasto_select")[0];
    select_base.selectedIndex = parseInt(temp[0]) - 1;

    updateClaseDeGasto();

    var select = $("#tipo_de_gasto_select")[0];
    select.selectedIndex = parseInt(temp[1]) - 1;

    updateTipoSelected();

}

function quitarConfirmar(){

    var child = document.getElementsByClassName("confirmar_button");
    
    var length = child.length;

    for (i = 0; i < length; i++) {

        child[i].innerHTML = "NO CERRADO";
        //child[i].parentNode.removeChild(child[i]);

    } 

}

function quitarRechazar(){

    var child = document.getElementsByClassName("rechazar_button");
    
    var length = child.length;

    for (i = 0; i < length; i++) {

        child[i].parentNode.removeChild(child[i]);

    } 

}

function enableButtons(){

    var child = document.getElementsByClassName("action_button");
    
    var length = child.length;

    for (i = 0; i < length; i++) {

        child[i].disabled = false;

    } 

}

function disableButtons(){

    var child = document.getElementsByClassName("action_button");
    
    var length = child.length;

    for (i = 0; i < length; i++) {

        child[i].disabled = true;

    } 

}

var clase_de_gasto_selected;
var tipo_de_gasto_selected;
var base_index;

function updateClaseDeGasto(){

    if(dont_show_clasificacion){

        return;

    }

    var clases_de_gasto_json = JSON.parse($('#clases_de_gasto').attr('value'));

    var select_base = $("#clase_de_gasto_select")[0];

    $('#clase_de_gasto_select')
      .find('option')
      .remove()
      .end();

    for(i = 0; i < clases_de_gasto_json.length; i++){

        select_base.add(new Option(clases_de_gasto_json[i].numero + " | " + clases_de_gasto_json[i].nombre, parseInt(clases_de_gasto_json[i].numero)));

    }

    clase_de_gasto_selected = select_base.selectedIndex + 1;

    updateTipoDeGasto();

}

function updateClaseSelected(){

    var select_base = $("#clase_de_gasto_select")[0];

    clase_de_gasto_selected = select_base.selectedIndex + 1;

    updateTipoDeGasto();
}

function updateTipoDeGasto(){

    var tipos_de_gasto_json = JSON.parse($('#tipos_de_gasto').attr('value'));

    var select = $("#tipo_de_gasto_select")[0];

    $('#tipo_de_gasto_select')
      .find('option')
      .remove()
      .end();

    for(i = 0; i < tipos_de_gasto_json.length; i++){

        if(parseInt(tipos_de_gasto_json[i].clase_de_gasto_id) == clase_de_gasto_selected){

            if(parseInt(tipos_de_gasto_json[i].numero) == 1){

                base_index = i;

            }

            select.add(new Option(
                clase_de_gasto_selected + "." + tipos_de_gasto_json[i].numero + " | " + 
                tipos_de_gasto_json[i].nombre,
                 parseInt(tipos_de_gasto_json[i].numero)));

        }

    }

    updateTipoSelected();

}

function updateTipoSelected(){

    var tipos_de_gasto_json = JSON.parse($('#tipos_de_gasto').attr('value'));

    tipo_de_gasto_selected = $('#tipo_de_gasto_select')[0].selectedIndex + 1;

    var index_to_use = base_index + $('#tipo_de_gasto_select')[0].selectedIndex;

    document.getElementById('descripcion_gasto').innerHTML = tipos_de_gasto_json[index_to_use].descripcion;

}
