$(document).ready(function(){
  $('#arbol').jstree(
  {
    "plugins" : [ "search" ]
  });
  
  $('#arbol').on('select_node.jstree', function(event, data){
    data.instance.toggle_node(data.node);
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
});





