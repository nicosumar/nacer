
$(document).ready(function() {
    // Initialize Smart Wizard
    $('#wizard').smartWizard({
      labelNext:'Siguiente', // label for Next button
      labelPrevious:'Anterior', // label for Previous button
      labelFinish:'Finalizar'  // label for Finish button    
    });
         
}); 


/*
 // el que tenia con el steps.
$(document).ready(function(){
  $("#wizzard-pago").steps({
      headerTag: "h3",
      bodyTag: "section",
      transitionEffect: "slideLeft",
        stepsOrientation: "horizontal",
        onStepChanged: function (event, currentIndex, priorIndex) {
            var nextStep = '#wizzard-pago #wizzard-pago-p-' + currentIndex;
            var totalHeight = 0;
            $(nextStep).children().each(function () {
                totalHeight += $(this).outerHeight(true);
            });
            $(nextStep).parent().animate({ height: totalHeight }, 200);
        }
  });
});

*/
/*
 // ejemplo de transicion y resize
wizzard-pago-h-2
    $("#wizard").steps({
        headerTag: "h2",
        bodyTag: "section",
        transitionEffect: "slideLeft",
        stepsOrientation: "horizontal",
        onStepChanging: function (event, currentIndex, newIndex) {
            var nextStep = '#wizard #wizard-p-' + newIndex;
            var heightNextStep = $(nextStep).css('minHeight');
            $(nextStep).parent().animate({height:heightNextStep},200);
            return true; 
        }
    });
    "#wizzard-pago #wizzard-pago-p-2"
    "#wizzard-pago #wizzard-pago-p-2"
                    wizzard-pago-p-2
                    wizzard-pago-p-1


    */