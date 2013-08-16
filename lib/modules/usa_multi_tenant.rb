# -*- encoding : utf-8 -*-
module UsaMultiTenant

  module MetodosDeInstancia
    attr_accessor :esquema 
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

    when args[:where].blank? && args[:sql].blank?
      raise "Debe definir el simbolo :where o :sql en el hash"  
      return false
    when !args[:esquemas].blank?
      esquemas = self.set_only_schemas args[:esquemas]
      args.delete(:esquemas)
    when !args[:except].blank?
      esquemas = self.set_all_schemas args[:except]
      args.delete(:except)
    end

    filtro = args[:where] unless args[:where].blank?
    
    i = 0
    unless args[:values].blank?
      args[:values].each do |v|
        args[i.to_s+v.to_s] = v
        i+=1
      end
      args.delete(:values)
    end
    
    esquemas.each do |esq|
      begin
        set_schema(esq['nombre'])
        
        if args[:sql].blank?
          #args[:where] = "Select '#{esq['nombre']}' as esquema, * from #{self.table_name} " + filtro
          args[:where] = "Select * from #{self.table_name} " + filtro
          parametros = args.values.sort {|a,b| b <=> a }


          r = self.find_by_sql(parametros).each do |row|
            send :include, MetodosDeInstancia
            row.esquema = esq['multi_nombre']
          end
          resp <<= r
          resp.flatten! 1
        else
          #ejecuto sin select
          logger.warn "args --------------------------- #{args.inspect}"
          #para que primero quede el sql
          parametros = args.values.sort {|a,b| a <=> b }
          
          
          logger.warn "parametrosssssssss!!!!!!!!!!!!!!!!!!!!!!!  --------------- #{parametros.inspect}"

          r = self.find_by_sql(parametros).each do |row|
            send :include, MetodosDeInstancia
            row.esquema = esq['multi_nombre']
          end
          resp <<= r
          resp.flatten! 1
        end

        
        ActiveRecord::Base.connection.clear_query_cache
        
      rescue Exception => e
        raise "El sql puede no ser válido o no se encontro la tabla en los esquemas especificados. Detalles: #{e.message}" 
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

  def set_only_schemas(*argEsquemas)
    sql = "select schema_name \"nombre\" from information_schema.schemata
                                           where schema_name <> 'information_schema' 
                                           and schema_name not ilike 'pg_%' 
                                           and schema_name in ( "
    esquemas = []
    if !argEsquemas.blank?
      argEsquemas.flatten!
      argEsquemas.each {|e| esquemas << "'#{e}'"}
      #esquemas = argEsquemas
      streEsq = esquemas.join(", ")
      sql += streEsq + ")"
    end
    return ActiveRecord::Base.connection.select_all(sql)
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