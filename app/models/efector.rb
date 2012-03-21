class Efector < ActiveRecord::Base
  has_one :convenio_de_gestion
  belongs_to :departamento
  belongs_to :distrito
  belongs_to :grupo_de_efectores
  belongs_to :area_de_prestacion
  belongs_to :dependencia_administrativa
  has_one :convenio_de_administracion
  has_many :prestaciones_autorizadas
  has_many :asignaciones_de_nomenclador
  has_many :referentes

  validates_presence_of :cuie, :nombre
  validates_uniqueness_of :cuie

  def nombre_corto
    if nombre.length > 80 then
      nombre.first(77) + "..."
    else
      nombre
    end
  end

  def self.que_no_tengan_convenio
    Efector.find_by_sql("
      SELECT *
        FROM efectores
        WHERE (integrante = TRUE) AND NOT EXISTS (
          SELECT *
            FROM convenios_de_gestion
            WHERE convenios_de_gestion.efector_id = efectores.id)
        ORDER BY nombre;")
  end

  def self.que_tengan_convenio
    Efector.find_by_sql("
      SELECT *
        FROM efectores
        WHERE (integrente = TRUE) AND EXISTS (
          SELECT *
            FROM convenios_de_gestion
            WHERE convenios_de_gestion.efector_id = efectores.id)
        ORDER BY nombre;")
  end

  def self.que_no_son_administrados
    Efector.find_by_sql("
      SELECT *
        FROM efectores
        WHERE (integrante = TRUE) AND NOT EXISTS (
          SELECT *
            FROM convenios_de_administracion
            WHERE convenios_de_administracion.efector_id = efectores.id
              OR convenios_de_administracion.administrador_id = efectores.id)
        ORDER BY nombre;")
  end

  def self.del_administrador_sin_liquidar(administrador_id, liquidacion_id)
    Efector.find_by_sql("
      SELECT *
        FROM efectores
        WHERE integrante = TRUE
          AND EXISTS (
            SELECT *
              FROM convenios_de_gestion
              WHERE convenios_de_gestion.efector_id = efectores.id)
          AND (
            EXISTS (
              SELECT *
                FROM convenios_de_administracion
                WHERE convenios_de_administracion.administrador_id = '#{administrador_id}'
                  AND convenios_de_administracion.efector_id = efectores.id)
            OR efectores.id = '#{administrador_id}')
          AND NOT EXISTS (
            SELECT *
              FROM cuasi_facturas
              WHERE liquidacion_id = '#{liquidacion_id}'
                AND cuasi_facturas.efector_id = efectores.id)
        ORDER BY nombre;")
  end

  def self.que_son_administrados
    Efector.find_by_sql("
      SELECT *
        FROM efectores
        WHERE (integrante = TRUE) AND EXISTS (
          SELECT *
            FROM convenios_de_administracion
            WHERE convenios_de_administracion.efector_id = efectores.id)
        ORDER BY nombre;")
  end

  def self.administradores_y_no_administrados
    Efector.find_by_sql("
      SELECT *
        FROM efectores
        WHERE (integrante = TRUE) AND NOT EXISTS (
          SELECT *
            FROM convenios_de_administracion
            WHERE convenios_de_administracion.efector_id = efectores.id)
        ORDER BY EXISTS (
          SELECT *
            FROM convenios_de_administracion
            WHERE convenios_de_administracion.administrador_id = efectores.id) DESC,
          nombre;")
  end

  def self.administradores_y_autoadministrados
    Efector.find_by_sql("
      SELECT *
        FROM efectores
        WHERE (integrante = TRUE) AND
          EXISTS (
            SELECT *
              FROM convenios_de_administracion
              WHERE convenios_de_administracion.administrador_id = efectores.id
          ) OR (
          NOT EXISTS (
            SELECT *
              FROM convenios_de_administracion
              WHERE convenios_de_administracion.efector_id = efectores.id
          ) AND (
            EXISTS (
              SELECT *
                FROM convenios_de_gestion
                WHERE convenios_de_gestion.efector_id = efectores.id
          ))) ORDER BY nombre;")
  end
end
