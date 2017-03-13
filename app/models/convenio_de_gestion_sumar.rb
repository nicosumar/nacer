# -*- encoding : utf-8 -*-
class ConvenioDeGestionSumar < ActiveRecord::Base
  # NULLificar los campos de texto en blanco
  nilify_blanks

  # Los atributos siguientes pueden asignarse en forma masiva
  attr_accessible :numero, :efector_id, :email, :fecha_de_suscripcion, :fecha_de_inicio
  attr_accessible :fecha_de_finalizacion, :observaciones, :firmante_id

  # Los atributos siguientes solo pueden asignarse durante la creación
  attr_readonly :numero, :efector_id

  # Asociaciones
  belongs_to :efector
  belongs_to :firmante, :class_name => "Referente"
  has_many :prestaciones_autorizadas, :as => :autorizante_al_alta
  has_many :prestaciones_pdss_autorizadas, :as => :autorizante_al_alta
  has_many :addendas_sumar
  has_many :solicitudes_addendas
  # Validaciones
  validates_presence_of :numero, :efector_id, :fecha_de_inicio
  validates_uniqueness_of :efector_id
  validates_uniqueness_of :numero
  validate :verificar_fechas

  # verificar_fechas
  # Verifica que todos los campos de fecha contengan valores lógicos
  def verificar_fechas
    error_de_fecha = false

    # Fecha de suscripción
    if fecha_de_suscripcion && fecha_de_inicio && fecha_de_suscripcion > fecha_de_inicio
      errors.add(:fecha_de_suscripcion, 'no puede ser posterior a la fecha de inicio')
      error_de_fecha = true
    end

    # Fechas de inicio y finalización
    if fecha_de_inicio && fecha_de_finalizacion && fecha_de_inicio > fecha_de_finalizacion
      errors.add(:fecha_de_inicio, 'no puede ser posterior a la fecha de finalización')
      error_de_fecha = true
    end

    return !error_de_fecha
  end

  def nombre
    numero.to_s + " " + efector.nombre
  end

  def generar_numero_addenda_sumar_masivo
    numeros_de_addendas_sumar = addendas_sumar.where("numero like ?", "ADM-%").pluck("numero")
    numero_addenda = 0
    numero_convenio = self.numero[-3..-1]

    if numeros_de_addendas_sumar.present?
      numeros_de_addendas_sumar_array = []
      numeros_de_addendas_sumar.map do |numero_addenda_param|
        numero_addenda_str = numero_addenda_param[-4..-1]
        if numero_addenda_str.include? "-"
           numero_addenda_str.gsub! '-', '0'
        end
        numeros_de_addendas_sumar_array << numero_addenda_str.to_i
      end
      numero_addenda = numeros_de_addendas_sumar_array.sort.last
    end
    numero_addenda += 1
    "ADM-#{numero_convenio}-#{numero_addenda.to_s.rjust(3, '0')}" 
  end

  def obtener_nombre_firmante
    referente = efector.referentes.where(fecha_de_finalizacion: nil).last
    referente.present? ? referente.contacto.mostrado : "Sin firmante"
  end

  def prestaciones_pdss_autorizadas_decoradas
    PrestacionPdssAutorizada.efector_y_fecha(self.efector_id, self.fecha_de_inicio)
  end

end
