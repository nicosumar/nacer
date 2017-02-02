# -*- encoding : utf-8 -*-
class DatoReportableAsociado < ActiveRecord::Base
  # NULLificar los campos de texto en blanco
  nilify_blanks

  # Los atributos siguientes pueden asignarse en forma masiva
  attr_accessible :dato_reportable_requerido_id, :observaciones, :prestacion_brindada_id
  attr_accessible :valor_integer, :valor_big_decimal, :valor_date, :valor_string

  # Asociaciones
  belongs_to :prestacion_brindada, :inverse_of => :datos_reportables_asociados
  belongs_to :dato_reportable_requerido

  # Validaciones
  validates_presence_of :dato_reportable_requerido_id
  validate :dentro_del_intervalo_esperado?
  validate :dato_reportable_necesario_presente?

  # Advertencias generadas por las validaciones
  attr_accessor :advertencias

  # Variable de instancia para almacenar las advertencias
  @advertencias = {}

  def dato_reportable_necesario_presente?

    drr = dato_reportable_requerido
    dr = drr.dato_reportable
    if drr.nil? || !drr.necesario || !eval("valor_" + dr.tipo_ruby + ".blank?")
      true
    else
      errors.add(
        ("valor_" + dr.tipo_ruby).to_sym, "El valor del campo \"" + (dr.nombre_de_grupo ? dr.nombre_de_grupo + " " +
        dr.nombre.mb_chars.downcase.to_s : dr.nombre) + "\" no puede estar en blanco"
      )
      false
    end
  end

  def hay_advertencias?

    alguna_advertencia = false

    # Eliminar las advertencias anteriores (si hubiera alguna)
    @advertencias = {}

    drr = dato_reportable_requerido
    dr = drr.dato_reportable
    if drr.obligatorio && eval("valor_" + dr.tipo_ruby + ".blank?")
      if @advertencias.has_key?(("valor_" + dr.tipo_ruby).to_sym)
        @advertencias[("valor_" + dr.tipo_ruby).to_sym] << (
          "El valor del campo \"" +
          (dr.nombre_de_grupo ? dr.nombre_de_grupo + " " : "") + dr.nombre.mb_chars.downcase.to_s + "\" no puede estar en blanco"
        )
      else
        @advertencias.merge!(("valor_" + dr.tipo_ruby).to_sym => (
          ["El valor del campo \"" + (dr.nombre_de_grupo ? dr.nombre_de_grupo + " " +
          dr.nombre.mb_chars.downcase.to_s : dr.nombre) + "\" no puede estar en blanco"])
        )
      end
      alguna_advertencia = true
      #prestacion_brindada.datos_reportables_incompletos = true
    end

    return alguna_advertencia
  end

  def dentro_del_intervalo_esperado?
    drr = dato_reportable_requerido
    dr = drr.dato_reportable
    if drr.nil? || eval("valor_" + dr.tipo_ruby + ".blank?") || !drr.minimo && !drr.maximo
      return true
    elsif (drr.minimo && drr.maximo && (eval("valor_" + dr.tipo_ruby + ".to_f") < drr.minimo.to_f ||
           eval("valor_" + dr.tipo_ruby + ".to_f") > drr.maximo.to_f))
      errors.add(
        ("valor_" + dr.tipo_ruby).to_sym, "El valor del campo \"" + (dr.nombre_de_grupo ? dr.nombre_de_grupo + " " +
        dr.nombre.mb_chars.downcase.to_s : dr.nombre) + "\" no está dentro del intervalo esperado (" +
        ('%0.2f' % drr.minimo.to_f) + " - " + ('%0.2f' % drr.maximo.to_f) + ")"
      )
      return false
    elsif drr.minimo && eval("valor_" + dr.tipo_ruby + ".to_f") < drr.minimo.to_f
      errors.add(
        ("valor_" + dr.tipo_ruby).to_sym, "El valor del campo \"" + (dr.nombre_de_grupo ? dr.nombre_de_grupo + " " +
        dr.nombre.mb_chars.downcase.to_s : dr.nombre) + "\" no puede ser inferior a " + ('%0.2f' % drr.minimo.to_f)
      )
      return false
    elsif drr.maximo && eval("valor_" + dr.tipo_ruby + ".to_f") > drr.maximo.to_f
      errors.add(
        ("valor_" + dr.tipo_ruby).to_sym, "El valor del campo \"" + (dr.nombre_de_grupo ? dr.nombre_de_grupo + " " +
        dr.nombre.mb_chars.downcase.to_s : dr.nombre) + "\" no puede ser superior a " + ('%0.2f' % drr.minimo.to_f)
      )
      return false
    else
      return true
    end
  end

end
