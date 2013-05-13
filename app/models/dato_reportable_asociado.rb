# -*- encoding : utf-8 -*-
class DatoReportableAsociado < ActiveRecord::Base
  # NULLificar los campos de texto en blanco
  nilify_blanks

  # Los atributos siguientes pueden asignarse en forma masiva
  attr_accessible :dato_reportable_id, :observaciones, :prestacion_brindada_id, :valor

  # Asociaciones
  belongs_to :dato_reportable
  belongs_to :prestacion_brindada, :inverse_of => :datos_reportables_asociados

  # Validaciones
  validates_presence_of :dato_reportable_id, :prestacion_brindada_id
  validates_presence_of :valor, :if => :dato_obligatorio?

  def dato_obligatorio?
    drr = (DatoReportableRequerido.where(:prestacion_id => self.prestacion_brindada.prestacion_id, :dato_reportable_id => dato_reportable_id) || []).first
    return true if drr && drr.obligatorio
    false
  end

end
