$(document).ready(function() {

  $('#menu ul > li').bind('mouseover', abrirSubmenu);
  $('#menu ul > li').bind('mouseout', cerrarSubmenu);

  function abrirSubmenu() {
    $(this).find('ul').css('visibility', 'visible');
  }

  function cerrarSubmenu() {
    $(this).find('ul').css('visibility', 'hidden');
  }

});
