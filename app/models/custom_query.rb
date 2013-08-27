# -*- encoding : utf-8 -*-
require 'usa_multi_tenant'
class CustomQuery < ActiveRecord::Base
  extend UsaMultiTenant

  attr_accessor :variables_de_busqueda

  def initialize(crear=false)
    #Creo la vista para que no chille en la inicializacion
    #TODO: Ver cuanto afecta la velocidad
    if crear
      ActiveRecord::Base.connection.execute <<-SQL 
        CREATE OR REPLACE TEMPORARY VIEW customes_queryes AS SELECT 1
        SQL
    end
    @filtros_de_busqueda = Hash.new
  end

  def nombres_columnas
    self.attributes.keys
  end
 
  def self.buscar(*args)
  	args = args.extract_options!

    if args.class.to_s != 'Hash' 
      raise "Debe enviar un hash como parametro"
      return nil
    end

    args.symbolize_keys!

    if args[:sql].blank?
      raise "Debe definir el simbolo :sql en el hash"  
  	  return nil
    end
    
    #Si hay parametros  
    if !args[:values].blank?
      i = 0
      args[:values].each do |v|
        args[i.to_s+v.to_s] =  v 
        i+=1
      end
    end
    args.delete(:values)
    
    #creo una vista temporal para evitar el error de que no existe la tabla del modelo
    ActiveRecord::Base.connection.execute <<-SQL 
      CREATE OR REPLACE TEMPORARY VIEW customes_queryes AS SELECT 1
  	  SQL

    #Si no existen estos parametros, busco en un solo esquema (el actual)
    if args[:except].blank? && args[:esquemas].blank?
      args.delete(:except)
      args.delete(:esquemas)
      begin
        return self.find_by_sql args.values
      rescue Exception => e
        raise "El sql puede no ser válido o no se encontro la tabla en los esquemas especificados. Detalles: #{e.message}"
      	return nil
      end
    else
      #si hay esquemas o exepct
      args[:esquemas] = args[:esquemas].collect { |s| "uad_"+ s.codigo } unless args[:esquemas].blank?
      args[:except] = args[:except].collect { |s| "uad_"+ s.codigo } unless args[:except].blank?
      begin
		return self.multi_find args
      rescue Exception => e
        raise "El sql puede no ser válido o no se encontro la tabla en los esquemas especificados. Detalles: #{e.message}"
      end

    end
  end

  private

  def persited?
    false
  end

end