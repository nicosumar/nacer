$(document).ready(function(){
  $('#arbol').jstree(
  {
    "plugins" : [ "wholerow" ]
  });
  
  $('#arbol').on('select_node.jstree', function(event, data){
    data.instance.toggle_node(data.node);
  });
});



