var datosReportables;

$(document).ready(function() {
  datosReportables = eval("[{\"clase_para_enumeracion\":null,\"enumerable\":false,\"id\":1,\"integra_grupo\":false,\"nombre\":\"Peso (en kilogramos)\",\"nombre_de_grupo\":null,\"opciones_de_formateo\":\"{:size => 6}\",\"orden_de_grupo\":null,\"tipo_ruby\":\"big_decimal\",\"codigo_de_grupo\":null},{\"clase_para_enumeracion\":null,\"enumerable\":false,\"id\":2,\"integra_grupo\":false,\"nombre\":\"Talla (en metros)\",\"nombre_de_grupo\":null,\"opciones_de_formateo\":\"{:size => 6}\",\"orden_de_grupo\":null,\"tipo_ruby\":\"big_decimal\",\"codigo_de_grupo\":null},{\"clase_para_enumeracion\":null,\"enumerable\":false,\"id\":3,\"integra_grupo\":false,\"nombre\":\"Edad gestacional (en semanas)\",\"nombre_de_grupo\":null,\"opciones_de_formateo\":\"{:size => 6}\",\"orden_de_grupo\":null,\"tipo_ruby\":\"big_decimal\",\"codigo_de_grupo\":null},{\"clase_para_enumeracion\":null,\"enumerable\":false,\"id\":4,\"integra_grupo\":true,\"nombre\":\"Sistólica\",\"nombre_de_grupo\":\"Tensión arterial\",\"opciones_de_formateo\":\"{:size => 6}\",\"orden_de_grupo\":1,\"tipo_ruby\":\"integer\",\"codigo_de_grupo\":\"ta\"},{\"clase_para_enumeracion\":null,\"enumerable\":false,\"id\":5,\"integra_grupo\":true,\"nombre\":\"Diastólica\",\"nombre_de_grupo\":\"Tensión arterial\",\"opciones_de_formateo\":\"{:size => 6}\",\"orden_de_grupo\":2,\"tipo_ruby\":\"integer\",\"codigo_de_grupo\":\"ta\"},{\"clase_para_enumeracion\":null,\"enumerable\":false,\"id\":6,\"integra_grupo\":true,\"nombre\":\"Caries\",\"nombre_de_grupo\":\"Índice CPOD\",\"opciones_de_formateo\":\"{:size => 3}\",\"orden_de_grupo\":1,\"tipo_ruby\":\"integer\",\"codigo_de_grupo\":\"cpod\"},{\"clase_para_enumeracion\":null,\"enumerable\":false,\"id\":7,\"integra_grupo\":true,\"nombre\":\"Perdidos\",\"nombre_de_grupo\":\"Índice CPOD\",\"opciones_de_formateo\":\"{:size => 3}\",\"orden_de_grupo\":2,\"tipo_ruby\":\"integer\",\"codigo_de_grupo\":\"cpod\"},{\"clase_para_enumeracion\":null,\"enumerable\":false,\"id\":8,\"integra_grupo\":true,\"nombre\":\"Obturados\",\"nombre_de_grupo\":\"Índice CPOD\",\"opciones_de_formateo\":\"{:size => 3}\",\"orden_de_grupo\":3,\"tipo_ruby\":\"integer\",\"codigo_de_grupo\":\"cpod\"},{\"clase_para_enumeracion\":null,\"enumerable\":false,\"id\":9,\"integra_grupo\":false,\"nombre\":\"Hemoglobina\",\"nombre_de_grupo\":null,\"opciones_de_formateo\":\"{:size => 6}\",\"orden_de_grupo\":null,\"tipo_ruby\":\"big_decimal\",\"codigo_de_grupo\":null},{\"clase_para_enumeracion\":null,\"enumerable\":false,\"id\":10,\"integra_grupo\":false,\"nombre\":\"Diagnóstico\",\"nombre_de_grupo\":null,\"opciones_de_formateo\":\"{:size => 60}\",\"orden_de_grupo\":null,\"tipo_ruby\":\"text\",\"codigo_de_grupo\":null},{\"clase_para_enumeracion\":\"SiNo\",\"enumerable\":true,\"id\":11,\"integra_grupo\":false,\"nombre\":\"Aspiración manual endouterina (AMEU)\",\"nombre_de_grupo\":null,\"opciones_de_formateo\":null,\"orden_de_grupo\":null,\"tipo_ruby\":\"integer\",\"codigo_de_grupo\":null},{\"clase_para_enumeracion\":null,\"enumerable\":false,\"id\":12,\"integra_grupo\":false,\"nombre\":\"Peso del recién nacido\",\"nombre_de_grupo\":null,\"opciones_de_formateo\":\"{:size => 6}\",\"orden_de_grupo\":null,\"tipo_ruby\":\"integer\",\"codigo_de_grupo\":null},{\"clase_para_enumeracion\":null,\"enumerable\":false,\"id\":13,\"integra_grupo\":false,\"nombre\":\"Fecha de parto\",\"nombre_de_grupo\":null,\"opciones_de_formateo\":null,\"orden_de_grupo\":null,\"tipo_ruby\":\"date\",\"codigo_de_grupo\":null},{\"clase_para_enumeracion\":null,\"enumerable\":false,\"id\":14,\"integra_grupo\":true,\"nombre\":\"En UTI\",\"nombre_de_grupo\":\"Días de internación\",\"opciones_de_formateo\":\"{:size => 3}\",\"orden_de_grupo\":1,\"tipo_ruby\":\"integer\",\"codigo_de_grupo\":\"di\"},{\"clase_para_enumeracion\":null,\"enumerable\":false,\"id\":15,\"integra_grupo\":true,\"nombre\":\"En sala común\",\"nombre_de_grupo\":\"Días de internación\",\"opciones_de_formateo\":\"{:size => 3}\",\"orden_de_grupo\":2,\"tipo_ruby\":\"integer\",\"codigo_de_grupo\":\"di\"},{\"clase_para_enumeracion\":null,\"enumerable\":false,\"id\":16,\"integra_grupo\":true,\"nombre\":\"Oído derecho\",\"nombre_de_grupo\":\"Resultados del estudio\",\"opciones_de_formateo\":\"{:size => 3}\",\"orden_de_grupo\":1,\"tipo_ruby\":\"text\",\"codigo_de_grupo\":\"re\"},{\"clase_para_enumeracion\":null,\"enumerable\":false,\"id\":17,\"integra_grupo\":true,\"nombre\":\"Oído izquierdo\",\"nombre_de_grupo\":\"Resultados del estudio\",\"opciones_de_formateo\":\"{:size => 3}\",\"orden_de_grupo\":2,\"tipo_ruby\":\"text\",\"codigo_de_grupo\":\"re\"},{\"clase_para_enumeracion\":null,\"enumerable\":false,\"id\":18,\"integra_grupo\":false,\"nombre\":\"Grado de retinopatía\",\"nombre_de_grupo\":null,\"opciones_de_formateo\":\"{:size => 6}\",\"orden_de_grupo\":null,\"tipo_ruby\":\"integer\",\"codigo_de_grupo\":null},{\"clase_para_enumeracion\":null,\"enumerable\":false,\"id\":19,\"integra_grupo\":true,\"nombre\":\"Días de estada pre-quirúrgicos\",\"nombre_de_grupo\":\"Detalle de la internación\",\"opciones_de_formateo\":\"{:size => 3}\",\"orden_de_grupo\":1,\"tipo_ruby\":\"integer\",\"codigo_de_grupo\":\"dicc\"},{\"clase_para_enumeracion\":null,\"enumerable\":false,\"id\":20,\"integra_grupo\":true,\"nombre\":\"Días de estada post-quirúrgica en UTI\",\"nombre_de_grupo\":\"Detalle de la internación\",\"opciones_de_formateo\":\"{:size => 3}\",\"orden_de_grupo\":2,\"tipo_ruby\":\"integer\",\"codigo_de_grupo\":\"dicc\"},{\"clase_para_enumeracion\":null,\"enumerable\":false,\"id\":21,\"integra_grupo\":true,\"nombre\":\"Días de medicación post-quirúrgica\",\"nombre_de_grupo\":\"Detalle de la internación\",\"opciones_de_formateo\":\"{:size => 3}\",\"orden_de_grupo\":3,\"tipo_ruby\":\"integer\",\"codigo_de_grupo\":\"dicc\"},{\"clase_para_enumeracion\":null,\"enumerable\":false,\"id\":22,\"integra_grupo\":true,\"nombre\":\"Días de estada post-quirúrgica en UTI con medicación\",\"nombre_de_grupo\":\"Detalle de la internación\",\"opciones_de_formateo\":\"{:size => 3}\",\"orden_de_grupo\":4,\"tipo_ruby\":\"integer\",\"codigo_de_grupo\":\"dicc\"},{\"clase_para_enumeracion\":null,\"enumerable\":false,\"id\":23,\"integra_grupo\":true,\"nombre\":\"Días de estada post-quirúrgica en sala común\",\"nombre_de_grupo\":\"Detalle de la internación\",\"opciones_de_formateo\":\"{:size => 3}\",\"orden_de_grupo\":5,\"tipo_ruby\":\"integer\",\"codigo_de_grupo\":\"dicc\"},{\"clase_para_enumeracion\":null,\"enumerable\":false,\"id\":24,\"integra_grupo\":false,\"nombre\":\"Valor cubierto (costo de la última compra en pesos)\",\"nombre_de_grupo\":null,\"opciones_de_formateo\":\"{:size => 10}\",\"orden_de_grupo\":null,\"tipo_ruby\":\"big_decimal\",\"codigo_de_grupo\":null},{\"clase_para_enumeracion\":null,\"enumerable\":false,\"id\":25,\"integra_grupo\":false,\"nombre\":\"Talla (en centímetros)\",\"nombre_de_grupo\":null,\"opciones_de_formateo\":\"{:size => 6}\",\"orden_de_grupo\":null,\"tipo_ruby\":\"integer\",\"codigo_de_grupo\":null},{\"clase_para_enumeracion\":null,\"enumerable\":false,\"id\":26,\"integra_grupo\":false,\"nombre\":\"Perímetro cefálico (en centímetros)\",\"nombre_de_grupo\":null,\"opciones_de_formateo\":\"{:size => 6}\",\"orden_de_grupo\":null,\"tipo_ruby\":\"integer\",\"codigo_de_grupo\":null}]");
});
