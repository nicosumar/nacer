# -*- encoding : utf-8 -*-
class EstadoDeLaPrestacion < ActiveRecord::Base

  has_many :parametros_liquidaciones_aceptadas, class_name: "ParametroLiquidacionSumar", foreign_key: 'aceptar_estado_de_la_prestacion_id'
  has_many :parametros_liquidaciones_rechazadas, class_name: "ParametroLiquidacionSumar", foreign_key: 'rechazar_estado_de_la_prestacion_id'
  has_many :parametros_liquidaciones_exceptuadas, class_name: "ParametroLiquidacionSumar", foreign_key: 'excepcion_estado_de_la_prestacion_id'
  has_many :prestaciones_liquidadas  
  has_many :anexos_administrativos_prestaciones

  # Seguridad de asignaciones masivas
  attr_accessible :codigo, :indexable, :nombre, :pendiente

  # id_del_codigo
  # Devuelve el ID asociado con el código pasado
  def self.id_del_codigo(codigo)
    if !codigo || codigo.strip.empty?
      return nil
    end

    # Buscar el código en la tabla y devolver su ID (si existe)
    estado_de_la_prestacion = self.find_by_codigo(codigo.strip.upcase)
    if estado_de_la_prestacion
      return estado_de_la_prestacion.id
    else
      return nil
    end
  end
  def self.id_del_codigo!(codigo)
    codigo_id = self.id_del_codigo(codigo)
    raise ActiveRecord::RecordNotFound if codigo_id.nil?
    return codigo_id
  end

end
