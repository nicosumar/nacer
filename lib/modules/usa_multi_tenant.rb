# -*- encoding : utf-8 -*-
module UsaMultiTenant

  attr_accessor :esquemas
  attr_accessor :esquema
  attr_accessor :excepto

  def hola
    true
  end

  def chau
    "chau"
  end

  def find_by_sql(*args)
    logger.warn "HOLaAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
    args = args.extract_options!
    esquemas = []
    resp = []
    logger.warn "ARGRS!!!!!!!!!!!!!!!!!!!!:#{args}  - es hash?: " + (args.class == "Hash").to_s + "       class: '" +args.class.to_s+"'"

    if args.class.to_s != 'Hash' 
      return false 
    end
    args.symbolize_keys!

    case 

    when args[:sql].blank? 
      raise "Debe definir el simbolo :sql en el hash"  
      return false
    when !args[:esquemas].blank?
      #TODO: Agregar para que use todos los esquemas elegidos
    when !args[:except].blank?
      esquemas = self.set_all_schemas args[:except]
      args.delete(:except)
    end

    logger.warn "todos los argumentos son: #{args.values.to_s}"
    esquemas.each do |esq|
      #begin
        logger.warn "El esquema actual es: #{esq['nombre']} " 
        logger.warn "El query es: " + args[:sql]
        logger.warn "Los valores a enviar a find_by son " + args.values.to_s
        logger.warn "la cantidad de esquemas es #{esquemas.size}"
        
        if set_schema(esq['nombre'])
          logger.warn "El esquema se seteo correctamente"   
        else
          logger.warn "El esquema no se seteo"   
        end 
        logger.warn "La clase actual es :#{self.to_s}"
        r = (args.values).each do |r| 
          r.esquema = esq['nombre'].to_s
          resp <<= r
        end
        ActiveRecord::Base.connection.clear_query_cache
        
      #rescue
       # raise "El sql puede no ser válido o no se encontro la tabla en los esquemas especificados" 
       # return false
      #end
    end
    return resp
  end

  def set_schema(nombre)

    logger.warn "set_schema.."
    logger.warn "nombre de la superclase:  #{self.superclass.name}" 
    logger.warn "#{self.superclass.name}"
    begin
    if self.superclass.name == "ActiveRecord::Base" && !nombre.blank?
      #Ok, esta el modulo incluido en un Modelo
      ActiveRecord::Base.connection.clear_cache!
      ActiveRecord::Base.connection.schema_search_path = "#{nombre}, public"
      ActiveRecord::Base.connection.clear_cache!
      logger.debug "El searchpath actual es #{ActiveRecord::Base.connection.schema_search_path.split(",").first.to_s}"
      return true
    end
    rescue 
      raise "Ocurrio un error. :S. Tal vez el esquema \'#{nombre}\'' no existe"
      return false
    end
  end
  
  def set_all_schemas(*argExcepto)

    logger.warn "Aca llego #{argExcepto}.to_s"
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

    logger.warn "el sql #{sql}"
    return ActiveRecord::Base.connection.select_all(sql)
    
  end

end