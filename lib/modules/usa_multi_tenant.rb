# -*- encoding : utf-8 -*-
module UsaMultiTenant

  module MetodosDeInstancia
  
   #attr_accessor :esquema 

  end

  def multi_find(*args)
    args = args.extract_options!
    esquemas = []
    resp = []

    if args.class.to_s != 'Hash' 
      return false 
    end
    args.symbolize_keys!

    case 

    when args[:where].blank? 
      raise "Debe definir el simbolo :where en el hash"  
      return false
    when !args[:esquemas].blank?
      #TODO: Agregar para que use todos los esquemas elegidos
    when !args[:except].blank?
      esquemas = self.set_all_schemas args[:except]
      args.delete(:except)
    end

    filtro = args[:where]
    i = 0
    args[:values].each do |v|
      args[i.to_s+v.to_s] = v
      i+=1
    end
    args.delete(:values)
    
    esquemas.each do |esq|
      begin
        set_schema(esq['nombre'])
        
        args[:where] = "Select '#{esq['nombre']}' as esquema, * from #{self.table_name} " + filtro
        r = self.find_by_sql(args.values)
        resp <<= r
        resp.flatten! 1
        ActiveRecord::Base.connection.clear_query_cache
        
      rescue
        raise "El sql puede no ser válido o no se encontro la tabla en los esquemas especificados" 
        return false
      end
    end
    send :include, MetodosDeInstancia
    return resp
  end

  def set_schema(nombre)
    begin
      if self.superclass.name == "ActiveRecord::Base" && !nombre.blank?

        #Ok, esta el modulo incluido en un Modelo
        ActiveRecord::Base.connection.clear_cache!
        ActiveRecord::Base.connection.schema_search_path = "#{nombre}, public"
        return true
      end
    rescue 
      raise "Ocurrio un error. :S. Tal vez el esquema \'#{nombre}\'' no existe"
      return false
    end
  end
  
  def set_all_schemas(*argExcepto)
    sql = "select schema_name \"nombre\" from information_schema.schemata
                                           where schema_name <> 'information_schema' 
                                           and schema_name not ilike 'pg_%' "
    excepto = []
    if !argExcepto.blank?
      argExcepto.flatten!
      excepto += argExcepto
      excepto.each do |esq|
        sql += "and schema_name != '#{esq}' "
      end
    end 
    return ActiveRecord::Base.connection.select_all(sql)
  end  


  

end