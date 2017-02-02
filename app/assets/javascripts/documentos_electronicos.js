$(document).ready(function(){
  $('#arbol').jstree(
  {
    "plugins" : [ "search" ]
  });
  
  $('#arbol').on('select_node.jstree', function(event, data){
    data.instance.toggle_node(data.node);
  });

  $('#arbol').on('changed.jstree', function(event, data){
    if(data.node.a_attr.href != "#")
      window.location.href = data.node.a_attr.href;
  });

  var to = false;
  $('#arbol_q').keyup(function () {
    if(to)
    { 
      clearTimeout(to); 
    }
    to = setTimeout(function () {
      var v = $('#arbol_q').val();
      $('#arbol').jstree(true).search(v);
    }, 1000);
  });

  $("#expandir").on("click", function(e){
    //Si checkea comunitaria, desactivo la busqueda de afiliados
    if($(this).is(':checked') == "1") 
    {
      $('#arbol').jstree('open_all');
    }
    else
    {
      $('#arbol').jstree('close_all');
    }
  });
  
});





