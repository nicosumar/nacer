# -*- encoding : utf-8 -*-
class ProcesoDeDatosExternos < ActiveRecord::Base
  # Seguridad de asignaciones masivas
  attr_accessible :archivo_de_datos, :hash_de_archivo, :notificar_por_email, :proceso_finalizado, :proceso_iniciado
  attr_accessible :proceso_solicitado, :tipo_de_proceso_id

  # Asociaciones
  belongs_to :tipo_de_proceso

  # Validaciones
  validates :tipo_de_proceso_id, :presence => true
  validates :archivo_de_datos_fingerprint, :uniqueness => true

  # Paperclip
  has_attached_file :archivo_de_datos, :styles => lambda {|adjunto| { :text => { :tipo_de_proceso => adjunto.instance.tipo_de_proceso } } }
  validates_attachment :archivo_de_datos, :presence => true, :content_type => { :content_type => ["text/plain", "text/csv"] }

  def procesar
    eval(modelo_de_datos).procesar_datos_externos(archivo_de_datos_fingerprint)
  end

  def eliminar_tabla_de_preprocesamiento
    return nil if tabla_de_preprocesamiento.blank?
    ActiveRecord::Base.connection.execute <<-SQL
      DROP TABLE IF EXISTS "procesos"."#{tabla_de_preprocesamiento}" CASCADE;
    SQL
  end

  # Paperclip before_post_process callback
  def before_post_process
  end

  # Paperclip after_post_process callback
  def after_post_process
  end

end
