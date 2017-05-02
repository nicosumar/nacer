# -*- encoding : utf-8 -*-
class AddendaSumar < ActiveRecord::Base
  # NULLificar los campos de texto en blanco
  nilify_blanks

  # Los atributos siguientes pueden asignarse en forma masiva
  attr_accessible :convenio_de_gestion_sumar_id, :firmante, :fecha_de_suscripcion, :fecha_de_inicio, :observaciones, :numero

  # Los atributos siguientes solo pueden asignarse durante la creación
  attr_readonly :convenio_de_gestion_sumar_id, :fecha_de_inicio, :numero

  # Asociaciones
  belongs_to :convenio_de_gestion_sumar
  has_many :prestaciones_autorizadas_alta, :as => :autorizante_al_alta, :class_name => "PrestacionAutorizada"
  has_many :prestaciones_autorizadas_baja, :as => :autorizante_de_la_baja, :class_name => "PrestacionAutorizada"

  # Validaciones
  validates_presence_of :convenio_de_gestion_sumar_id, :fecha_de_inicio
  validates_uniqueness_of :numero
  validate :validar_fechas
  #validate :validar_existencia_de_addenda_posterior

  # Verifica que la fecha de suscripción no sea posterior a la fecha de inicio
  def validar_fechas
    unless fecha_de_suscripcion.nil? or fecha_de_inicio.nil? then
      if fecha_de_suscripcion > fecha_de_inicio then
        errors.add(:fecha_de_suscripcion, "no puede ser posterior a la fecha de inicio.")
        return false
      end
    end
    return true
  end

  def validar_existencia_de_addenda_posterior
    unless fecha_de_suscripcion.nil? or fecha_de_inicio.nil? or convenio_de_gestion_sumar.nil? then
      if convenio_de_gestion_sumar.addendas_sumar.where("fecha_de_suscripcion >= ?", fecha_de_suscripcion).exists? then
        errors.add(:fecha_de_suscripcion, "existe una adenda generada con fecha superior.")
        return false
      end
    end
    return true
  end

  def validar_existencia_de_addenda_posterior_edit
    unless fecha_de_suscripcion.nil? or fecha_de_inicio.nil? or convenio_de_gestion_sumar.nil? then
      if convenio_de_gestion_sumar.addendas_sumar.where("fecha_de_suscripcion >= ? and id != ?", fecha_de_suscripcion, id ).exists? then
        errors.add(:fecha_de_suscripcion, "existe una adenda generada con fecha superior.")
        return false
      end
    end
    return true
  end
end

