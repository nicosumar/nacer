# -*- encoding : utf-8 -*-
class TipoDeAgrupacion < ActiveRecord::Base
  
  has_many :documentos_generables_por_conceptos

  attr_accessible :nombre, :codigo

  # 
  # Itera los efectores haciendo cortes segun el criterio indicado para una liquidación dada
  #  Itera sobre los efectores que correspondan y devuelve las prestaciones liquidadas sobre 
  # el tipo de incumbencia de la agrupacion.
  # @param  liquidacion [LiquidacionSumar] Liquidacion sobre la cual debe iterar
  # 
  # @return [type] [description]
  def iterar_efectores_y_prestaciones_de(liquidacion)

    case self.codigo.strip

    when "SEA" # Itera solo los efectores administradores de los efectores liquidados
      efectores_id = liquidacion.prestaciones_liquidadas.
                  select("convenios_de_administracion_sumar.administrador_id").
                  joins(:efector, "JOIN convenios_de_administracion_sumar on convenios_de_administracion_sumar.efector_id = efectores.id").
                  group("convenios_de_administracion_sumar.administrador_id").
                  collect { |r|  r.administrador_id }
      Efector.where(id: efectores_id).each do |e|
        yield e, Efector.prestaciones_liquidadas_por_liquidacion(liquidacion, true, e.efectores_administrados)
      end

    when "EAH" # Efectores Administradores y hospitales
      efectores_id = liquidacion.prestaciones_liquidadas.
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
                      collect { |r|  r.efector_id }
      efectores_id << liquidacion.prestaciones_liquidadas.
                  select("convenios_de_administracion_sumar.administrador_id").
                  joins(:efector, "JOIN convenios_de_administracion_sumar on convenios_de_administracion_sumar.efector_id = efectores.id").
                  group("convenios_de_administracion_sumar.administrador_id").
                  collect { |r|  r.administrador_id }
      efectores_id.flatten! 1
      
      Efector.where(id: efectores_id).each do |e|
        if e.es_administrador?
          yield e, e.prestaciones_liquidadas_por_liquidacion(liquidacion, true, e.efectores_administrados)
        else
          yield e, e.prestaciones_liquidadas_por_liquidacion(liquidacion, true)
        end
      end

    when "E" # Efectores
      efectores_id = liquidacion.prestaciones_liquidadas.
                      select(:efector_id).
                      group(:efector_id).
                      collect { |r|  r.efector_id }
      
      Efector.where(id: efectores_id).each do |e|
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
