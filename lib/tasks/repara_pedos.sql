begin;
update prestaciones_brindadas 
	SET estado_de_la_prestacion_id = p.estado_de_la_prestacion_id
--select  p.unidad_de_alta_de_datos_id, p.prestacion_brindada_id
from liquidaciones_sumar l
	join prestaciones_liquidadas p on p.liquidacion_id = l.id 
	join efectores e on e.id = p.efector_id
where l."id" in (9)
and p.created_at > to_date('2013-1-12', 'yyyy-dd-mm') --l.created_at
and e.id not in (72, 343)
and prestaciones_brindadas.id = p.prestacion_brindada_id
;

DELETE FROM anexos_medicos_prestaciones WHERE prestacion_liquidada_id IN (
select  p.id
from liquidaciones_sumar l
	join prestaciones_liquidadas p on p.liquidacion_id = l.id 
	join efectores e on e.id = p.efector_id
where l."id" in (9)
and p.created_at > to_date('2013-1-12', 'yyyy-dd-mm') --l.created_at
and e.id not in (72, 343));

DELETE FROM prestaciones_liquidadas_advertencias WHERE prestacion_liquidada_id IN (
select  p.id
from liquidaciones_sumar l
	join prestaciones_liquidadas p on p.liquidacion_id = l.id 
	join efectores e on e.id = p.efector_id
where l."id" in (9)
and p.created_at > to_date('2013-1-12', 'yyyy-dd-mm') --l.created_at
and e.id not in (72, 343));

DELETE FROM prestaciones_liquidadas_datos WHERE prestacion_liquidada_id IN (
select  p.id
from liquidaciones_sumar l
	join prestaciones_liquidadas p on p.liquidacion_id = l.id 
	join efectores e on e.id = p.efector_id
where l."id" in (9)
and p.created_at > to_date('2013-1-12', 'yyyy-dd-mm') --l.created_at
and e.id not in (72, 343));

DELETE FROM prestaciones_liquidadas WHERE id IN (
select  p.id
from liquidaciones_sumar l
	join prestaciones_liquidadas p on p.liquidacion_id = l.id 
	join efectores e on e.id = p.efector_id
where l."id" in (9)
and p.created_at > to_date('2013-1-12', 'yyyy-dd-mm') --l.created_at
and e.id not in (72, 343));

/**************************************************************************
REPARAR PEDO 2 
***************************************************************************/
-- PASO 1 - ELIMINA FUTUOS PEDOS EN LOS ANEXOS MEDICOS MAL GENERADOS
delete 
from anexos_medicos_prestaciones 
where id in (
select  amp."id" 
from liquidaciones_informes li 
	join liquidaciones_sumar_anexos_medicos am on am.id = li.liquidacion_sumar_anexo_medico_id
	join anexos_medicos_prestaciones amp on  amp.liquidacion_sumar_anexo_medico_id = am.id
	join prestaciones_liquidadas p on p.id = amp.prestacion_liquidada_id
where li.aprobado = 't'
and li.estado_del_proceso_id not in (4)
and p.estado_de_la_prestacion_liquidada_id = 6
);
-- restaura el estado de la prestacion liquidada 
UPDATE prestaciones_liquidadas set estado_de_la_prestacion_liquidada_id = 6 where id in (
select  amp.prestacion_liquidada_id  -- p.liquidacion_id--p.estado_de_la_prestacion_id, count(p.*)
from liquidaciones_informes li 
	join liquidaciones_sumar_anexos_medicos am on am.id = li.liquidacion_sumar_anexo_medico_id
	join anexos_medicos_prestaciones amp on  amp.liquidacion_sumar_anexo_medico_id = am.id
	join prestaciones_liquidadas p on p.id = amp.prestacion_liquidada_id
where li.aprobado = 't'
and li.estado_del_proceso_id in (4)
and p.estado_de_la_prestacion_id = 2
and p.observaciones_liquidacion is not null
);
-- Borra las prestaciones mal incluidas en los anexos  medicos
delete 
from anexos_medicos_prestaciones
where id in (
select  amp.id  -- p.liquidacion_id--p.estado_de_la_prestacion_id, count(p.*)
from liquidaciones_informes li 
	join liquidaciones_sumar_anexos_medicos am on am.id = li.liquidacion_sumar_anexo_medico_id
	join anexos_medicos_prestaciones amp on  amp.liquidacion_sumar_anexo_medico_id = am.id
	join prestaciones_liquidadas p on p.id = amp.prestacion_liquidada_id
where li.aprobado = 't'
and li.estado_del_proceso_id in (4)
and p.estado_de_la_prestacion_id = 2
and p.observaciones_liquidacion is not null
);