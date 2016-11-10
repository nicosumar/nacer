# -*- encoding : utf-8 -*-
class AsignacionMasivaOrdenAPrestacionPdss

  def self.execute
    ActiveRecord::Base.transaction do

      GrupoPdss.all.each do |grupo_pdss|
        grupo_pdss.prestaciones_pdss.order("orden ASC").each_with_index do |prestacion_pdss, index|
          puts "GRUPO: #{ grupo_pdss.id } PRESTACION_PDSS ORDEN ANTERIOR: #{prestacion_pdss.orden} NUEVO: #{index + 1}"
          prestacion_pdss.update_attributes(orden: (index + 1))
        end
      end

    end
  end

end
