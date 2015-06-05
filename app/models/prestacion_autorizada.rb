# -*- encoding : utf-8 -*-
class PrestacionAutorizada < ActiveRecord::Base
  # No se declara ningún atributo protegido ya que este modelo se modifica indirectamente
  # a través de las adendas y convenios de gestión
  attr_protected nil

  # Asociaciones
  belongs_to :efector
  belongs_to :prestacion
  belongs_to :autorizante_al_alta, :polymorphic => true
  belongs_to :autorizante_de_la_baja, :polymorphic => true
  has_many :prestaciones_pdss, :through => :prestacion

  # Validaciones
  validates_presence_of :efector_id, :prestacion_id, :fecha_de_inicio

  # Devuelve las prestaciones autorizadas para el ID del efector que se pasa como parámetro
  # y que aún no han sido dadas de baja.
  def self.autorizadas(efector_id)
    PrestacionAutorizada.select(" DISTINCT ON ( prestaciones_autorizadas.*) prestaciones_autorizadas.*, prestaciones.codigo,
                                  CASE mp.grupo WHEN '1' THEN 'Embarazo'
                                    WHEN '2' THEN '0 a 6 años'
                                    WHEN '3' THEN '6 a 9 años'
                                    WHEN '4' THEN '10 a 19 años'
                                    WHEN '5' THEN '20 a 64 años'
                                    ELSE 'No agrupadas'
                                  END \"grupo\",  mp.grupo \"grupo_id\", subgrupo").
                        joins("INNER JOIN prestaciones ON (prestaciones_autorizadas.prestacion_id = prestaciones.id)").
                        joins("INNER JOIN vista_migra_pss mp on mp.id_subrrogada_foranea = prestaciones.id ").
                        joins("INNER JOIN asignaciones_de_precios ap ON ( ap.prestacion_id = prestaciones_autorizadas.prestacion_id )").
                        where("efector_id = ?", efector_id).
                        where("ap.area_de_prestacion_id = ?", Efector.find(efector_id).area_de_prestacion_id).
                        where("fecha_de_finalizacion IS NULL")
  end

  # Devuelve las prestaciones que estaban autorizadas para el ID del efector
  # antes de la fecha indicada en los parámetros.
  def self.autorizadas_antes_del_dia(efector_id, fecha)
    PrestacionAutorizada.select(" DISTINCT ON (prestaciones_autorizadas.*) prestaciones_autorizadas.*, prestaciones.codigo, 
                                    CASE mp.grupo WHEN '1' THEN 'Embarazo'
                                      WHEN '2' THEN '0 a 6 años'
                                      WHEN '3' THEN '6 a 9 años'
                                      WHEN '4' THEN '10 a 19 años'
                                      WHEN '5' THEN '20 a 64 años'
                                      ELSE 'No agrupadas'
                                    END \"grupo\",  mp.grupo \"grupo_id\", subgrupo").
                          joins(" INNER JOIN prestaciones ON (prestaciones_autorizadas.prestacion_id = prestaciones.id)").
                          joins(" INNER JOIN vista_migra_pss mp on mp.id_subrrogada_foranea = prestaciones.id").
                          where(" efector_id = ?", efector_id).
                          where(" fecha_de_inicio < ?", fecha.strftime("%Y-%m-%d")).
                          where(" (fecha_de_finalizacion IS NULL OR fecha_de_finalizacion >= ?) ", fecha.strftime("%Y-%m-%d"))
  end
end
