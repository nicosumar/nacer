module UsaMultiTenant2

  attr_accessor :esquemas
  attr_accessor :esquema


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

  # Esta implementación busca un tipo de query en particular, deberia definir una que reciba solo los binds
  def buscar_por_sql(sql="", binds=[] =[])
  	
  	
  	if @esquemas.blank?
  		set_all_schemas
  	end
  	
  	resp = []

  	@esquemas.each do |esq|
  	  begin
  	  	
  	  	set_schema(esq)
  	    query = "Select * from #{self.table_name} where estado_de_la_novedad_id = 2 and tipo_de_novedad_id = 2"
  		r = self.find_by_sql(sql, binds).each do |r| 
  			r.esquema = esq.to_s
  			resp <<= r
  		end


	  rescue 
  	  	raise "El sql puede no ser válido"
  		return false
  	  end

  	end
  end
  
  def set_all_schemas
  	@esquemas = ActiveRecord::Base.connection.select_all("select schema_name \"nombre\" from information_schema.schemata")
                                           #where schema_name <> 'information_schema' 
                                           #and schema_name !~ E'^pg_")
  	
  end

end