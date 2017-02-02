$(document).ready(function() {
  
  //Por defecto setea el lenguaje SQL como predeterminado ocultando el de ruby
  $("textarea[name*='informe[metodo]']").hide();

  /* Si esta editando y rails devuelve datos en uno de los dos campos,
     setea el radio button y muestra el textarea correcto para el informe
  */		
  if( $("textarea[name*='informe[sql]']").val() != "")
  {
  	$("input[name*='lenguaje'][value=1]").prop('checked', true);
  	//muestro y oculto los textarea
  	$("textarea[name*='informe[metodo]']").hide();
  	$("textarea[name*='informe[sql]']").show();
    $('.fila_esquemas').show().fadeIn(500);
  }
  else
  {
  	$("input[name*='lenguaje'][value=0]").prop('checked', true);
  	//muestro y oculto los textarea
	  $("textarea[name*='informe[sql]']").hide();
    $("textarea[name*='informe[metodo]']").show();
    $('.fila_esquemas').hide().fadeOut(500);
  }

  //           BINDINGS
  $("input[name*='lenguaje']").bind('click',function(){
    //$('input[name=radioName]:checked', '#myForm').val()
    if( $(this).val() == 1)
    {
      $('#secccion-lenguaje').html("SQL" ) ;
  	  // si es sql, blanqueo el texto de codigo ruby
  	  $("textarea[name*='informe[metodo]']").val("");
  	  //muestro y oculto los textarea
  	  $("textarea[name*='informe[metodo]']").hide();
  	  $("textarea[name*='informe[sql]']").show();
      $('.fila_esquemas').fadeIn(500);
    }
    else	//eligio ruby
    {
      $('#secccion-lenguaje').html("Ruby" ) ;
      // si es sql, blanqueo el texto de codigo ruby
      $("textarea[name*='informe[sql]']").val("");
      //muestro y oculto los textarea
      $("textarea[name*='informe[sql]']").hide();
      $("textarea[name*='informe[metodo]']").show();
      $('.fila_esquemas').fadeOut(500);
    }
  });
});
