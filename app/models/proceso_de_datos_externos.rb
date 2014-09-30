# -*- encoding : utf-8 -*-
class ProcesoDeDatosExternos < ActiveRecord::Base
  # Seguridad de asignaciones masivas
  attr_accessible :archivo_de_datos, :hash_de_archivo, :notificar_por_email, :proceso_finalizado, :proceso_iniciado
  attr_accessible :proceso_solicitado, :tipo_de_proceso_id

  # Asociaciones
  belongs_to :tipo_de_proceso

  # Validaciones
  validates :tipo_de_proceso_id, :presence => true
  validates :archivo_de_datos_file_name, :presence => true
  validates :hash_de_archivo, :uniqueness => true

  def procesar
    eval(modelo_de_datos).procesar_datos_externos(hash_de_archivo)
  end

end
