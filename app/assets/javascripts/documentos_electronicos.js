$(document).ready(function(){
  $('#arbol').jstree(
  {
    "plugins" : [ "wholerow", "search" ]
  });
  
  $('#arbol').on('select_node.jstree', function(event, data){
    data.instance.toggle_node(data.node);
  });

  var to = false;
  $('#busqueda').keyup(function () {
    if(to)
    { 
      clearTimeout(to); 
    }
    to = setTimeout(function () {
      var v = $('#busqueda').val();
      $('#arbol').jstree(true).search(v);
    }, 250);
  });
});




