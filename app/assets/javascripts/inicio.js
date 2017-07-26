function toggleDisplay(element, show) {

    if(element){

        if (show) {
            element.style.display = 'block';
        } else {
            element.style.display = 'none';
        }

    }
}

function ToggleNotificaciones(element, objective_element_id){

  var objective_element = document.getElementById(objective_element_id);

  var current_status = objective_element.style.display;

  if(current_status == 'none')
  {

    element.innerHTML = "ʌ"

    toggleDisplay(objective_element, true);

    if(objective_element_id == "seccion_notificaciones"){

      toggleDisplay(document.getElementById('seccion_info_notificaciones'), false);

    }

  }
  else {

    element.innerHTML = "v"

    toggleDisplay(objective_element, false);

    if(objective_element_id == "seccion_notificaciones"){

      toggleDisplay(document.getElementById('seccion_info_notificaciones'), false);

    }

  }


}

