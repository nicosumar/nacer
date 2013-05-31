# -*- encoding : utf-8 -*-
class DatoReportableAsociado < ActiveRecord::Base
  # NULLificar los campos de texto en blanco
  nilify_blanks

  # Los atributos siguientes pueden asignarse en forma masiva
  attr_accessible :dato_reportable_id, :observaciones, :prestacion_brindada_id
  attr_accessible :valor_integer, :valor_big_decimal, :valor_date, :valor_text

  # Asociaciones
  belongs_to :dato_reportable
  belongs_to :prestacion_brindada, :inverse_of => :datos_reportables_asociados

  # Validaciones
  validates_presence_of :dato_reportable_id
  validate :dato_reportable_necesario_presente?

  # Advertencias generadas por las validaciones
  attr_accessor :advertencias

  # Variable de instancia para almacenar las advertencias
  @advertencias = {}

  def dato_reportable_necesario_presente?
    drr = (
      DatoReportableRequerido.where(
        :prestacion_id => prestacion_brindada.prestacion_id, :dato_reportable_id => dato_reportable_id
      ) || []
    ).first
    if drr.nil? || !drr.necesario || !eval("valor_" + drr.dato_reportable.tipo_ruby + ".blank?")
      true
    else
      errors.add(
        ("valor_" + drr.dato_reportable.tipo_ruby).to_sym, "El valor del campo \"" + (drr.dato_reportable.nombre_de_grupo ?
        drr.dato_reportable.nombre_de_grupo + " " + drr.dato_reportable.nombre.mb_chars.downcase.to_s :
        drr.dato_reportable.nombre) + "\" no puede estar en blanco"
      )
      false
    end
  end

  def hay_advertencias?

    alguna_advertencia = false

    # Eliminar las advertencias anteriores (si hubiera alguna)
    @advertencias = {}

    drr = (
      DatoReportableRequerido.where(:prestacion_id => prestacion_brindada.prestacion_id,
      :dato_reportable_id => dato_reportable_id) || []
    ).first
    if drr.obligatorio && eval("valor_" + drr.dato_reportable.tipo_ruby + ".blank?")
      if @advertencias.has_key?(("valor_" + drr.dato_reportable.tipo_ruby).to_sym)
        @advertencias[("valor_" + drr.dato_reportable.tipo_ruby).to_sym] << (
          "El valor del campo \"" +
          (drr.dato_reportable.nombre_de_grupo ? drr.dato_reportable.nombre_de_grupo + " " : "") +
          drr.dato_reportable.nombre.mb_chars.downcase.to_s + "\" no puede estar en blanco"
        )
      else
        @advertencias.merge!(("valor_" + drr.dato_reportable.tipo_ruby).to_sym => (
          ["El valor del campo \"" + (drr.dato_reportable.nombre_de_grupo ? drr.dato_reportable.nombre_de_grupo + " " +
          drr.dato_reportable.nombre.mb_chars.downcase.to_s : drr.dato_reportable.nombre) + "\" no puede estar en blanco"])
        )
      end
      alguna_advertencia = true
      prestacion_brindada.datos_reportables_incompletos = true
    end

    return alguna_advertencia
  end
end
