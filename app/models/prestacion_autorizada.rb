class PrestacionAutorizada < ActiveRecord::Base
  # No se declara ningún atributo protegido ya que este modelo se modifica indirectamente
  # a través de las adendas y convenios de gestión
  attr_protected nil

  # Asociaciones
  belongs_to :efector
  belongs_to :prestacion
  belongs_to :autorizante_al_alta, :polymorphic => true
  belongs_to :autorizante_de_la_baja, :polymorphic => true

  # Validaciones
  validates_presence_of :efector_id, :prestacion_id, :fecha_de_inicio

  # Devuelve las prestaciones autorizadas para el ID del efector que se pasa como parámetro
  # y que aún no han sido dadas de baja.
  def self.autorizadas(efector_id)
    PrestacionAutorizada.find_by_sql("
      SELECT prestaciones_autorizadas.*
        FROM prestaciones_autorizadas
          INNER JOIN prestaciones ON (prestaciones_autorizadas.prestacion_id = prestaciones.id)
        WHERE efector_id = \'#{efector_id}\' AND fecha_de_finalizacion IS NULL
        ORDER BY prestaciones.codigo;")
  end

  # Devuelve las prestaciones que estaban autorizadas para el ID del efector
  # antes de la fecha indicada en los parámetros.
  def self.autorizadas_antes_del_dia(efector_id, fecha)
    PrestacionAutorizada.find_by_sql("
      SELECT prestaciones_autorizadas.*
        FROM prestaciones_autorizadas
          INNER JOIN prestaciones ON (prestaciones_autorizadas.prestacion_id = prestaciones.id)
        WHERE efector_id = '#{efector_id}' AND fecha_de_inicio < '#{fecha.strftime("%Y-%m-%d")}'
          AND (fecha_de_finalizacion IS NULL OR fecha_de_finalizacion >= '#{fecha.strftime("%Y-%m-%d")}')
        ORDER BY prestaciones.codigo;")
  end
end
