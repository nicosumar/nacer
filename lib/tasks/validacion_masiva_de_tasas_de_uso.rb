# -*- encoding : utf-8 -*-
archivo = File.open('lib/tasks/datos/validacion_tasas.csv', 'w')
archivo.puts "Codigo UAD\tID prestación brindada\tClave de beneficiario\tID prestación\tAcción"
#ActiveRecord::Base.transaction do
  UnidadDeAltaDeDatos.where(:facturacion => true).order(:codigo).each do |u|
    ActiveRecord::Base.connection.schema_search_path = "uad_#{u.codigo}, public"
    PrestacionBrindada.where("fecha_de_la_prestacion >= '2014-05-01' AND estado_de_la_prestacion_id IN (2, 3)").order(:fecha_de_la_prestacion, :id).each do |pb|
      if pb.estado_de_la_prestacion_id == 2 && (pb.metodos_de_validacion_fallados.size == 0 || pb.metodos_de_validacion_fallados.any?{|mvf| [15, 16].member?(mvf.metodo_de_validacion_id)})
        pb.actualizar_metodos_de_validacion_fallados
        if pb.metodos_de_validacion_fallados.size == 0
          pb.estado_de_la_prestacion_id = 3
        end
        pb.save
        if not pb.metodos_de_validacion_fallados.any?{|mvf| [15, 16].member?(mvf.metodo_de_validacion_id)}
          archivo.puts "#{u.codigo}\t#{pb.id}\t#{pb.clave_de_beneficiario}\t#{pb.prestacion_id}\tAdvertencia de tasa de uso eliminada"
        else
          archivo.puts "#{u.codigo}\t#{pb.id}\t#{pb.clave_de_beneficiario}\t#{pb.prestacion_id}\tAdvertencia de tasa de uso mantenida"
        end
        archivo.flush
      elsif pb.estado_de_la_prestacion_id == 3
        pb.actualizar_metodos_de_validacion_fallados
        if pb.metodos_de_validacion_fallados.size > 0
          pb.estado_de_la_prestacion_id = 2
        end
        pb.save
        if pb.metodos_de_validacion_fallados.any?{|mvf| [15, 16].member?(mvf.metodo_de_validacion_id)}
          archivo.puts "#{u.codigo}\t#{pb.id}\t#{pb.clave_de_beneficiario}\t#{pb.prestacion_id}\tAdvertencia de tasa de uso agregada"
          archivo.flush
        end
      end
    end
  end
#end

archivo.close
