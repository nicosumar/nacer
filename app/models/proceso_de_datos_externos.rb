class ProcesoDeDatosExternos < ActiveRecord::Base
  belongs_to :tipo_de_proceso
  attr_accessible :archivo_de_datos, :hash_de_archivo, :notificar_por_email, :proceso_finalizado, :proceso_iniciado, :proceso_solicitado
end
