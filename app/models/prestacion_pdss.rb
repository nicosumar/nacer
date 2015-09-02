# -*- encoding : utf-8 -*-
class PrestacionPdss < ActiveRecord::Base

  # Los atributos siguientes pueden asignarse en forma masiva
  attr_accessible :nombre, :linea_de_cuidado_id, :orden, :grupo_pdss_id
  attr_accessible :tipo_de_prestacion_id, :modulo_id

  # Asociaciones
  belongs_to :grupo_pdss
  belongs_to :linea_de_cuidado
  belongs_to :modulo
  belongs_to :tipo_de_prestacion
  has_and_belongs_to_many :prestaciones
  has_and_belongs_to_many :areas_de_prestacion

  # Devuelve las prestaciones que no han sido autorizadas para el ID del efector que se pasa
  # como parámetro.
  def self.no_autorizadas_sumar(efector_id)
    PrestacionPdss.find_by_sql("
      SELECT prestaciones_pdss.*
        FROM prestaciones_pdss
        WHERE
          id NOT IN (
            SELECT prestacion_pdss_id
              FROM prestaciones_pdss_autorizadas
              WHERE efector_id = \'#{efector_id}\' AND fecha_de_finalizacion IS NULL
          )
        ORDER BY codigo;")
  end

  # Devuelve las prestaciones que no han sido autorizadas para el ID del efector
  # hasta el dia anterior de la fecha indicada en los parámetros.
  def self.no_autorizadas_antes_del_dia(efector_id, fecha)
    Prestacion.find_by_sql("
      SELECT prestaciones.*
        FROM prestaciones
        WHERE id NOT IN (
          SELECT prestacion_id
            FROM prestaciones_autorizadas
            WHERE efector_id = \'#{efector_id}\' AND fecha_de_inicio < '#{fecha.strftime("%Y-%m-%d")}'
              AND (fecha_de_finalizacion IS NULL OR fecha_de_finalizacion >= '#{fecha.strftime("%Y-%m-%d")}')
        ) ORDER BY codigo;")
  end

end
