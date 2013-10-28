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

    when args[:sql].blank?
      raise "Debe definir el simbolo :sql en el hash"  
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

    #para que primero quede el sql
    psql = [args[:sql]]
    args.delete(:sql)
    pvalores = args.values
    parametros = psql + pvalores
    
    esquemas.each do |esq|
      begin
        set_schema(esq['nombre'])
        
        r = self.find_by_sql(parametros).each do |row|
          send :include, MetodosDeInstancia
          row.esquema = esq['nombre']
        end
        resp <<= r
        resp.flatten! 1

        ActiveRecord::Base.connection.clear_query_cache

      rescue Exception => e
        raise "El sql puede no ser válido o no se encontro la tabla en los esquemas especificados. Detalles: #{e.message}" 
        return false
      end
    end
    send :include, MetodosDeInstancia
    return resp
  end

  def multi_execute(*args)
    args = args.extract_options!
    esquemas = []
    resp = []

    if args.class.to_s != 'Hash' 
      return false 
    end
    args.symbolize_keys!

    case 

    when args[:sql].blank?
      raise "Debe definir el simbolo :sql en el hash"  
      return false
    when !args[:esquemas].blank?
      esquemas = self.set_only_schemas args[:esquemas]
      args.delete(:esquemas)
    when !args[:except].blank?
      esquemas = self.set_all_schemas args[:except]
      args.delete(:except)
    end

    i = 0
    unless args[:values].blank?
      args[:values].each do |v|
        args[i.to_s+v.to_s] = v
        i+=1
      end
      args.delete(:values)
    end

    #para que primero quede el sql
    psql = [args[:sql]]
    args.delete(:sql)
    pvalores = args.values
    parametros = psql + pvalores
    parametros = parametros.first unless parametros.count > 1 
    esquemas.each do |esq|
      begin
        set_schema(esq['nombre'])
        
        r = ActiveRecord::Base.connection.execute(parametros)

        ActiveRecord::Base.connection.clear_query_cache

      rescue Exception => e
        raise "El sql puede no ser válido o no se encontro la tabla en los esquemas especificados. Detalles: #{e.message}" 
        return false
      end
    end
    send :include, MetodosDeInstancia
    return true
    
  end

  def set_schema(nombre)
    begin
      if self.superclass.name == "ActiveRecord::Base" && !nombre.blank?

        #Ok, esta el modulo incluido en un Modelo
        ActiveRecord::Base.connection.clear_cache!
        ActiveRecord::Base.connection.schema_search_path = "#{nombre}, public"
        logger.warn "Se cambio al esquema #{nombre}"
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
                                           and schema_name <> 'public'
                                           and schema_name in ( "
    esquemas = []
    if !argEsquemas.blank?
      argEsquemas.flatten!
      argEsquemas.each {|e| esquemas << "'#{e}'"}
      streEsq = esquemas.join(", ")
      sql += streEsq + ")"
    end
    return ActiveRecord::Base.connection.select_all(sql)
  end
  
  def set_all_schemas(*argExcepto)
    sql = "select schema_name \"nombre\" from information_schema.schemata
                                           where schema_name <> 'information_schema' 
                                           and schema_name not ilike 'pg_%' 
                                           and schema_name <> 'public'"
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