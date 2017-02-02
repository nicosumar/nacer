$(document).ready(function() {
    var cantidadMinima = 10;
    var cantidadMaxima = 20;
    var a = $('#asistente')[0].outerHTML;
    if ($('#asistentes').children('#asistente').length < 2){
        $('#asistentes').children('#asistente').remove();
        $('#asistentes').hide();
    }
    $(document.body).on('click', '.agregar' ,function(){
        if($('#asistentes').children('#asistente').length < cantidadMaxima){
            if($('#asistentes').children('#asistente').length == 0){
                for (var i=0; i<cantidadMinima; i++) {
                    $('#prestacion_brindada_datos_reportables_asociados_attributes_1_valor_integer').val(cantidadMinima);
                    $('#asistentes').append(a);
                }
            } else {
                $('#prestacion_brindada_datos_reportables_asociados_attributes_1_valor_integer').val(parseInt("10", $('#prestacion_brindada_datos_reportables_asociados_attributes_1_valor_integer').val()) + 1);
                $('#asistentes').append(a);
            }
        } else {
            alert("El número máximo de asistentes al taller es " + cantidadMaxima + ".");
        }
        //$('#asistentes').children('#asistente').children('.fecha_de_nacimiento').datepicker({  dateFormat: "dd-mm-yy", showOn: "button", buttonImage: "/assets/calendar.gif", buttonImageOnly: true });
    });
    /*$(document).on("focus", ".datepicker", function(){
        $(this).datepicker();
    });*/
    $(document.body).on('click', '.quitar' ,function(){
        if($('#asistentes').children('#asistente').length > cantidadMinima){
            $('#prestacion_brindada_datos_reportables_asociados_attributes_1_valor_integer').val(parseInt("10", $('#prestacion_brindada_datos_reportables_asociados_attributes_1_valor_integer').val()) - 1);
            $(this).parent().remove();
        } else {
            alert("El número minimo de asistentes al taller es " + cantidadMinima + ".");
        }
    });
    $(document.body).on('click', '.quitarTodos' ,function(){
        $('#prestacion_brindada_datos_reportables_asociados_attributes_1_valor_integer').val(0);
        $('#asistentes').children('#asistente').remove();
    });
    $(document.body).on('change', '.select2' ,function(){
        if($('#prestacion_brindada_datos_reportables_asociados_attributes_1_valor_integer').val() == 0){
            $('#asistentes').show();
            $('#prestacion_brindada_datos_reportables_asociados_attributes_1_valor_integer').val(0);
            $('#prestacion_brindada_datos_reportables_asociados_attributes_1_valor_integer').prop('readonly', "readonly");
            $('#asistentes').children('#asistente').remove();
        } else {
            $('#asistentes').children('#asistente').remove();
            $('#asistentes').hide();
        }
    });
}); 