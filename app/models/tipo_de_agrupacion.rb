# -*- encoding : utf-8 -*-
class TipoDeAgrupacion < ActiveRecord::Base
  
  has_many :documentos_generables_por_conceptos

  attr_accessible :nombre, :codigo

  # 
  # Itera los efectores haciendo cortes segun el criterio indicado para una liquidación dada
  # @param  liquidacion [type] [description]
  # 
  # @return [type] [description]
  def iterar_efectores_y_prestaciones_de(liquidacion)

    case self.codigo.strip
    when "EAH" # Efectores Administradores y hospitales
      cabecera = true
      Efector.administradores_y_autoadministrados_sumar.
             where(id: liquidacion.prestaciones_liquidadas.select(:efector_id).
                                   group(:efector_id).
                                   collect { |r|  r.efector_id }
                   ).order(:id).
              each do |e|
                e.prestaciones_liquidadas_por_liquidacion(liquidacion, true).each do |pl|
                  yield e, pl, cabecera
                  cabecera = false
                end
                cabecera = true
              end

    when "E" # Efectores
      cabecera = true
      Efector.where(id:  liquidacion.prestaciones_liquidadas
                                    .select(:efector_id)
                                    .group(:efector_id)
                                    .collect { |r|  r.efector_id }
                    ).order(:id)
              each do |e|
                e.prestaciones_liquidadas_por_liquidacion(liquidacion, true).each do |pl|
                  yield e, pl, cabecera
                  cabecera = false
                end
                cabecera = true
              end
    when "EA" # Afiliados
      cabecera = true
      Efector.where(id:  liquidacion.prestaciones_liquidadas
                                    .select(:efector_id)
                                    .group(:efector_id, :clave_de_beneficiario)
                                    .collect { |r|  r.efector_id }
                                ).order(:id).
              each do |e|
                e.prestaciones_liquidadas_por_liquidacion(liquidacion, true).each do |pl|
                  yield e, pl, cabecera
                  cabecera = false
                end
                cabecera = true
              end
  	end
  	
  end
end
