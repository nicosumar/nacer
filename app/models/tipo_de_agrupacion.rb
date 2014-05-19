# -*- encoding : utf-8 -*-
class TipoDeAgrupacion < ActiveRecord::Base
  
  has_many :documentos_generables_por_conceptos

  attr_accessible :nombre, :codigo

  # 
  # Itera los efectores haciendo cortes segun el criterio indicado para una liquidación dada
  # @param  liquidacion [LiquidacionSumar] Liquidacion sobre la cual debe iterar
  # 
  # @return [type] [description]
  def iterar_efectores_y_prestaciones_de(liquidacion)

    case self.codigo.strip
    when "EAH" # Efectores Administradores y hospitales
      liquidacion.prestaciones_liquidadas.
                  select(:efector_id).
                  joins(:efector).
                  where("(efectores.integrante = TRUE) AND
                          EXISTS (
                            SELECT *
                              FROM convenios_de_administracion_sumar
                              WHERE convenios_de_administracion_sumar.administrador_id = efectores.id
                          ) OR (
                          NOT EXISTS (
                            SELECT *
                              FROM convenios_de_administracion_sumar
                              WHERE convenios_de_administracion_sumar.efector_id = efectores.id
                          ) AND (
                            EXISTS (
                              SELECT *
                                FROM convenios_de_gestion_sumar
                                WHERE convenios_de_gestion_sumar.efector_id = efectores.id
                          ))) ").
                  group(:efector_id).
                  collect { |r|  r.efector_id }.
                  each do |e_id|
                    e = Efector.find(e_id) 
                    yield e, e.prestaciones_liquidadas_por_liquidacion(liquidacion, true)
                  end

    when "E" # Efectores
      liquidacion.prestaciones_liquidadas.
                  select(:efector_id).
                  group(:efector_id).
                  collect { |r|  r.efector_id }.
                  each do |e_id|
                    e = Efector.find(e_id) 
                    yield e, e.prestaciones_liquidadas_por_liquidacion(liquidacion, true)
                  end

    when "EA" # Efectores y Afiliados
      liquidacion.prestaciones_liquidadas.
                  select([:efector_id, :clave_de_beneficiario]).
                  group(:efector_id, :clave_de_beneficiario).order(:efector_id).
                  each do |r|
                    e = Efector.find(r.efector_id) 
                    yield e, e.prestaciones_liquidadas_por_liquidacion(liquidacion, true).where(clave_de_beneficiario: r.clave_de_beneficiario)
                  end
                  
  	end
  end
end
