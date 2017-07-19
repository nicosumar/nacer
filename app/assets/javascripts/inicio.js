$(document).ready(function(){

  toggleDisplay(document.getElementById('seccion_notificaciones'), false);
	
});


function ShowNotificaciones(){

  toggleDisplay(document.getElementById('seccion_ocultar_info_notificaciones'), true);
  toggleDisplay(document.getElementById('seccion_info_notificaciones'), false);
  toggleDisplay(document.getElementById('seccion_notificaciones'), true);

}

function HideNotificaciones(){

  toggleDisplay(document.getElementById('seccion_ocultar_info_notificaciones'), false);
  toggleDisplay(document.getElementById('seccion_info_notificaciones'), true);
  toggleDisplay(document.getElementById('seccion_notificaciones'), false);

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

