# -*- encoding : utf-8 -*-
class DatoReportableAsociado < ActiveRecord::Base
  # NULLificar los campos de texto en blanco
  nilify_blanks

  # Los atributos siguientes pueden asignarse en forma masiva
  attr_accessible :dato_reportable_id, :observaciones, :prestacion_brindada_id, :valor

  # Asociaciones
  belongs_to :dato_reportable
  belongs_to :prestacion_brindada

end
