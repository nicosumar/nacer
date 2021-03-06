# -*- encoding : utf-8 -*-
# Datos precargados al inicializar el sistema

class NormalizarDocumentacionRespaldatoria < ActiveRecord::Migration
  execute <<-SQL 
  	delete from documentaciones_respaldatorias;
  SQL
  DocumentacionRespaldatoria.create([
  { #:id => 1,
    :nombre => "Hoja de ruta",
    :codigo => "HR",
    :descripcion => "" }
  ])

  DocumentacionRespaldatoria.create([
  { #:id => 2,
    :nombre => "Plantilla de Reporte de Talleres",
    :codigo => "RT",
    :descripcion => "" }
  ])

  DocumentacionRespaldatoria.create([
  { #:id => 3,
    :nombre => "Informe de Ronda",
    :codigo => "IR",
    :descripcion => "" }
  ])
  
  execute <<-SQL
  	insert into documentaciones_respaldatorias_prestaciones 
  	(prestacion_id, documentacion_respaldatoria_id, fecha_de_inicio, fecha_de_finalizacion ,created_at, updated_at)
  	select p.id, (select id from documentaciones_respaldatorias where codigo = 'RT'), '2013/06/01',null ,now(), now()
  	from prestaciones p 
  	where codigo ilike 'TA%';

  	insert into documentaciones_respaldatorias_prestaciones 
  	(prestacion_id, documentacion_respaldatoria_id, fecha_de_inicio, fecha_de_finalizacion ,created_at, updated_at)
  	select p.id, (select id from documentaciones_respaldatorias where codigo = 'HR'), '2013/06/01',null ,now(), now()
  	from prestaciones p 
  	where codigo ilike 'TL%';

  	insert into documentaciones_respaldatorias_prestaciones 
  	(prestacion_id, documentacion_respaldatoria_id, fecha_de_inicio, fecha_de_finalizacion ,created_at, updated_at)
  	select p.id, (select id from documentaciones_respaldatorias where codigo = 'IR'), '2013/06/01',null ,now(), now()
  	from prestaciones p 
  	where codigo ilike 'RO%';
  SQL


end 
