require 'spreadsheet'

class MigraConvenios
  attr_accessor :rutayarchivo
  attr_accessor :hoja
  attr_accessor :efector
  attr_accessor :convenio
  attr_accessor :book
  attr_accessor :sheet


  #uso:
  # a = MigraConvenios.new('C:\Users\Pablo\Documents\Proyectos\Rails\nacer\lib\tasks\template ids.xls')
  # a.hoja = 1
  #
  def crear_convenio(convenio)
  	# TODO: AMAR INSERT A LA TABLA DE CONVENIOS
  	# algo como:
  	# @convenio = ConvenioDeGestion.new({muchos_parametros: 'a', .....})
  	# @convenio = convenio
  	# @convenio.save
  end



  def initialize(args)
	@rutayarchivo = args
	#@book = Spreadsheet.open @rutayarchivo
  	#@sheet = book.worksheet 1
  end
	


  def cargar_datos
    ActiveRecord::Base.connection.schema_search_path = "public"
    book = Spreadsheet.open @rutayarchivo
  	sheet = book.worksheet @hoja
  	id=0

  	#Cargo la seccion 1 - 1.1
  	sheet.each 43 do |row| 
  	  ActiveRecord::Base.connection.execute "
  	 	INSERT INTO migra_prestaciones 
  	 	  ( id ,  numero_fila ,  numero_columna_si_no ,  grupo ,  subgrupo ,  nosologia  ,  tipo_de_prestacion ,  nombre_prestacion ,  codigos                 ,  precio   ,  rural )  
  	 	  VALUES                                   
  	 	  (#{id}, #{row.idx+1} , 13                    , '1'    ,      '1.1',    '#{row[0]}',            '#{row[1]}',           '#{row[2]}', '#{row[8] + ' ' + row[10]}', '#{row[11]}', '#{row[12]}');"
  	 	id+=1
  	 	if (row.idx+1) == 95
  	 		break
  	 	end
  	end

  	#Cargo la seccion 1 - 1.2-A
  	sheet.each 99 do |row| 
  	  ActiveRecord::Base.connection.execute "
  	 	INSERT INTO migra_prestaciones 
  	 	  ( id ,  numero_fila ,  numero_columna_si_no ,  grupo ,  subgrupo ,  nosologia  ,  tipo_de_prestacion ,  nombre_prestacion ,  codigos                 ,  precio   ,  rural )  
  	 	  VALUES                                   
  	 	  (#{id}, #{row.idx+1} , 13                    , '1'    ,      '1.2-a',    '#{row[0]}',            '#{row[1]}',           '#{row[2]}', '#{row[8] + ' ' + row[10]}', '#{row[11]}', '#{row[12]}');"
  	 	id+=1
  	 	if (row.idx+1) == 162
  	 		break
  	 	end
  	end
  
  	#Cargo la seccion 2 - 2.1
  	sheet.each 190 do |row| 
  	  ActiveRecord::Base.connection.execute "
  	 	INSERT INTO migra_prestaciones 
  	 	  ( id ,  numero_fila ,  numero_columna_si_no ,  grupo ,  subgrupo ,  nosologia  ,  tipo_de_prestacion ,  nombre_prestacion ,  codigos                 ,  precio   ,  rural )  
  	 	  VALUES                                   
  	 	  (#{id}, #{row.idx+1} , 13                    , '2'    ,      '2.1',    '#{row[0]}',            '#{row[1]}',           '#{row[2]}', '#{row[8] + ' ' + row[10]}', '#{row[11]}', '#{row[12]}');"
  	 	id+=1
  	 	if (row.idx+1) == 200
  	 		break
  	 	end
  	end

  	#Cargo la seccion 2 - 2.5
  	sheet.each 226 do |row| 
  	  ActiveRecord::Base.connection.execute "
  	 	INSERT INTO migra_prestaciones 
  	 	  ( id ,  numero_fila ,  numero_columna_si_no ,  grupo ,  subgrupo ,  nosologia  ,  tipo_de_prestacion ,  nombre_prestacion ,  codigos                 ,  precio   ,  rural )  
  	 	  VALUES                                   
  	 	  (#{id}, #{row.idx+1} , 13                    , '2'    ,      '2.5', '#{row[0]}',          '#{row[1]}',         '#{row[2]}', '#{row[8]}', '#{row[11]}', '#{row[12]}');"
  	 	id+=1
  	 	if (row.idx+1) == 232
  	 		break
  	 	end
  	end

  	#Cargo la seccion 2 - 2.7
  	sheet.each 280 do |row| 
  	  ActiveRecord::Base.connection.execute "
  	 	INSERT INTO migra_prestaciones 
  	 	  ( id ,  numero_fila ,  numero_columna_si_no ,  grupo ,  subgrupo ,  nosologia  ,  tipo_de_prestacion ,  nombre_prestacion ,  codigos                 ,  precio   ,  rural )  
  	 	  VALUES                                   
  	 	  (#{id}, #{row.idx+1} , 13                    , '2'    ,      '2.7',    '#{row[0]}',            '#{row[1]}',           '#{row[2]}', '#{row[8] + ' ' + row[10]}', '#{row[11]}', '#{row[12]}');"
  	 	id+=1
  	 	if (row.idx+1) == 326
  	 		break
  	 	end
  	end

  	#Cargo la seccion 3 - 3.1
  	sheet.each 332 do |row| 
  	  ActiveRecord::Base.connection.execute "
  	 	INSERT INTO migra_prestaciones 
  	 	  ( id ,  numero_fila ,  numero_columna_si_no ,  grupo ,  subgrupo ,  nosologia  ,  tipo_de_prestacion ,  nombre_prestacion ,  codigos                 ,  precio   ,  rural )  
  	 	  VALUES                                   
  	 	  (#{id}, #{row.idx+1} , 13                    , '3'    ,      '3.1',    '#{row[0]}',            '#{row[1]}',           '#{row[2]}', '#{row[8] + ' ' + row[10]}', '#{row[11]}', '#{row[12]}');"
  	 	id+=1
  	 	if (row.idx+1) == 367
  	 		break
  	 	end
  	end

  	#Cargo la seccion 4 - 4.1
  	sheet.each 374 do |row| 
  	  ActiveRecord::Base.connection.execute "
  	 	INSERT INTO migra_prestaciones 
  	 	  ( id ,  numero_fila ,  numero_columna_si_no ,  grupo ,  subgrupo ,  nosologia  ,  tipo_de_prestacion ,  nombre_prestacion ,  codigos                 ,  precio   ,  rural )  
  	 	  VALUES                                   
  	 	  (#{id}, #{row.idx+1} , 13                    , '4'    ,      '4.1',    '#{row[0]}',            '#{row[1]}',           '#{row[2]}', '#{row[8] + ' ' + row[10]}', '#{row[11]}', '#{row[12]}');"
  	 	id+=1
  	 	if (row.idx+1) == 428
  	 		break
  	 	end
  	end

  	#Cargo la seccion 5 - 5.1
  	sheet.each 435 do |row| 
  	  ActiveRecord::Base.connection.execute "
  	 	INSERT INTO migra_prestaciones 
  	 	  ( id ,  numero_fila ,  numero_columna_si_no ,  grupo ,  subgrupo ,  nosologia  ,  tipo_de_prestacion ,  nombre_prestacion ,  codigos                 ,  precio   ,  rural )  
  	 	  VALUES                                   
  	 	  (#{id}, #{row.idx+1} , 13                    , '5'    ,      '5.1',    '#{row[0]}',            '#{row[1]}',           '#{row[2]}', '#{row[8] + ' ' + row[10]}', '#{row[11]}', '#{row[12]}');"
  	 	id+=1
  	 	if (row.idx+1) == 482
  	 		break
  	 	end
  	end

  	puts '-----------------------------------------------------------------'
  	puts 'se insertaron #{id-1} registros en la tabla de migra_prestaciones'
  	puts '-----------------------------------------------------------------'

  	idm=0

	#Cargo la seccion 1 - 1.2-B
	sheet.each 167 do |row| 
	  ActiveRecord::Base.connection.execute "
	    INSERT INTO migra_modulos 
	    ( id   ,  numero_fila ,  numero_columna_si_no ,  grupo ,  subgrupo ,   modulo ,  definicion_cirugia_conceptos ,  codigos       ) 
	    VALUES 
	    (#{idm},#{row.idx+1}  , 13                    , '1'    , '1.2-B'   , '#{row[2]}',                            NULL, '#{row[7]}' );"
      idm+=1
  	   if (row.idx+1) == 173
  	     break
  	   end
  	end

  	#Cargo la seccion 1 - 1.2-C
  	sheet.each 177 do |row| 
	  ActiveRecord::Base.connection.execute "
	    INSERT INTO migra_modulos 
	    ( id   ,  numero_fila ,  numero_columna_si_no ,  grupo ,  subgrupo ,   modulo ,  definicion_cirugia_conceptos ,  codigos       ) 
	    VALUES 
	    (#{idm},#{row.idx+1}  , 11                    , '1'    , '1.2-C'   , '#{row[2]}',                            NULL, '#{row[7]}' );"
      idm+=1
  	   if (row.idx+1) == 180
  	     break
  	   end
  	end

  	#Cargo la seccion 1 - 1.2-D
  	sheet.each 184 do |row| 
	  ActiveRecord::Base.connection.execute "
	    INSERT INTO migra_modulos 
	    ( id   ,  numero_fila ,  numero_columna_si_no ,  grupo ,  subgrupo ,   modulo ,  definicion_cirugia_conceptos ,  codigos       ) 
	    VALUES 
	    (#{idm},#{row.idx+1}  , 11                    , '1'    , '1.2-D'   , '#{row[0]}',                            NULL, '#{row[8]}' );"
      idm+=1
  	   if (row.idx+1) == 185
  	     break
  	   end
  	end

  	#Cargo la seccion 2 - 2.2
  	sheet.each 204 do |row| 
	  ActiveRecord::Base.connection.execute "
	  INSERT INTO migra_modulos 
	    ( id   ,  numero_fila ,  numero_columna_si_no ,  grupo ,  subgrupo ,   modulo ,  definicion_cirugia_conceptos ,  codigos       ) 
	    VALUES 
	    (#{idm},#{row.idx+1}  , 13                    , '2'    , '2.2'     , '#{row[1]}',                      '#{row[2]}', '#{row[0]}' );"
      idm+=1
  	   if (row.idx+1) == 207
  	     break
  	   end
  	end

  	#Cargo la seccion 2 - 2.3
  	sheet.each 211 do |row| 
	  ActiveRecord::Base.connection.execute "INSERT INTO migra_modulos 
	    ( id   ,  numero_fila ,  numero_columna_si_no ,  grupo ,  subgrupo ,   modulo ,  definicion_cirugia_conceptos ,  codigos       ) 
	    VALUES 
	    (#{idm},#{row.idx+1}  , 11                    , '2'    , '2.3'     , '#{row[2]}',                      NULL, '#{row[8]}' );"
      idm+=1
  	   if (row.idx+1) == 213
  	     break
  	   end
  	end


  	#Cargo la seccion 2 - 2.4
  	sheet.each 217 do |row| 
	  ActiveRecord::Base.connection.execute "
	    INSERT INTO migra_modulos 
	    ( id   ,  numero_fila ,  numero_columna_si_no ,  grupo ,  subgrupo ,   modulo ,  definicion_cirugia_conceptos ,  codigos       ) 
	    VALUES 
	    (#{idm},#{row.idx+1}  , 11                    , '2'    , '2.4'     , '#{row[2]}',                      NULL, '#{row[8]}' );"
      idm+=1
  	   if (row.idx+1) == 218
  	     break
  	   end
  	end

  	#Cargo la seccion 2 - 2.6
	sheet.each 236 do |row| 
	  ActiveRecord::Base.connection.execute "
	    INSERT INTO migra_modulos 
	    ( id   ,  numero_fila ,  numero_columna_si_no ,  grupo ,  subgrupo ,   modulo ,  definicion_cirugia_conceptos ,  codigos       ) 
	    VALUES 
	    (#{idm},#{row.idx+1}  , 13                    , '2'    , '2.6'     , '#{row[0]}',                      '#{row[1]}', '#{row[3]}' );"
      idm+=1
  	   if (row.idx+1) == 246
  	     break
  	   end
  	end

	sheet.each 249 do |row| 
	  ActiveRecord::Base.connection.execute "
	    INSERT INTO migra_modulos 
	    ( id   ,  numero_fila ,  numero_columna_si_no ,  grupo ,  subgrupo ,   modulo ,  definicion_cirugia_conceptos ,  codigos       ) 
	    VALUES 
	    (#{idm},#{row.idx+1}  , 13                    , '2'    , '2.6'     , '#{row[0]}',                      '#{row[1]}', '#{row[3]}' );"
      idm+=1
  	   if (row.idx+1) == 253
  	     break
  	   end
  	end

  	sheet.each 255 do |row| 
	  ActiveRecord::Base.connection.execute "
	    INSERT INTO migra_modulos 
	    ( id   ,  numero_fila ,  numero_columna_si_no ,  grupo ,  subgrupo ,   modulo ,  definicion_cirugia_conceptos ,  codigos       ) 
	    VALUES 
	    (#{idm},#{row.idx+1}  , 13                    , '2'    , '2.6'     , '#{row[0]}',                      '#{row[1]}', '#{row[3]}' );"
      idm+=1
  	   if (row.idx+1) == 260
  	     break
  	   end
  	end

  	sheet.each 262 do |row| 
	  ActiveRecord::Base.connection.execute "
	  INSERT INTO migra_modulos 
	    ( id   ,  numero_fila ,  numero_columna_si_no ,  grupo ,  subgrupo ,   modulo ,  definicion_cirugia_conceptos ,  codigos       ) 
	    VALUES 
	    (#{idm},#{row.idx+1}  , 13                    , '2'    , '2.6'     , '#{row[0]}',                      '#{row[1]}', '#{row[3]}' );"
      idm+=1
  	   if (row.idx+1) == 263
  	     break
  	   end
  	end

  	#Cargo la seccion 2 - 2.7
  	sheet.each 267 do |row| 
	  ActiveRecord::Base.connection.execute "
	  INSERT INTO migra_modulos 
	    ( id   ,  numero_fila ,  numero_columna_si_no ,  grupo ,  subgrupo ,   modulo ,  definicion_cirugia_conceptos ,  codigos       ) 
	    VALUES 
	    (#{idm},#{row.idx+1}  , 13                    , '2'    , '2.7'     , '#{row[0]}',                      '#{row[5]}', '#{row[3]}' );"
      idm+=1
  	   if (row.idx+1) == 276
  	     break
  	   end
  	end

	puts '-----------------------------------------------------------------'
  	puts 'se insertaron #{idM-1} registros en la tabla de migra_modulos'
  	puts '-----------------------------------------------------------------'

  	ida =0

  	#Cargo los anexos
  	sheet.each 487 do |row| 
	  ActiveRecord::Base.connection.execute "
 		INSERT INTO migra_anexos 
 		( id ,   numero_fila ,  numero_columna_si_no ,  prestaciones ,  anexo ,     codigo ) 
 		VALUES 
 		(#{ida}, #{row.idx+1},         13            , '#{row[0]}'     , '#{row[1]}', '#{row[10]}');"
 	  ida+=1
  	   if (row.idx+1) == 569
  	     break
  	   end
  	end

  	sheet.each 572 do |row| 
	  ActiveRecord::Base.connection.execute "
 		INSERT INTO migra_anexos 
 		( id ,   numero_fila ,  numero_columna_si_no ,  prestaciones ,  anexo ,     codigo ) 
 		VALUES 
 		(#{ida}, #{row.idx+1},         13            , '#{row[0]}'     , '#{row[1]}', '#{row[10]}');"
 	  ida+=1
  	   if (row.idx+1) == 657
  	     break
  	   end
  	end

  	sheet.each 660 do |row| 
	  ActiveRecord::Base.connection.execute "
 		INSERT INTO migra_anexos 
 		( id ,   numero_fila ,  numero_columna_si_no ,  prestaciones ,  anexo ,     codigo ) 
 		VALUES 
 		(#{ida}, #{row.idx+1},         13            , '#{row[0]}'     , '#{row[1]}',' #{row[10]}');"
 	  ida+=1
  	   if (row.idx+1) == 687
  	     break
  	   end
  	end

  end





  def self.crear_tablas
  	#Creo la tabla de mapeo sin los indices:

	#creo la tabla de prestaciones
	ActiveRecord::Base.connection.execute <<-SQL 
        -- ----------------------------
		-- Table structure for migra_prestaciones
		-- ----------------------------
		CREATE TABLE IF NOT EXISTS "public"."migra_prestaciones" (
		"id" int4 NOT NULL,
		"numero_fila" int4 NOT NULL,
		"numero_columna_si_no" int4 NOT NULL,
		"grupo" int4 NOT NULL,
		"subgrupo" varchar(100) COLLATE "default" NOT NULL,
		"nosologia" varchar(512) COLLATE "default" NOT NULL,
		"tipo_de_prestacion" text COLLATE "default" NOT NULL,
		"nombre_prestacion" text COLLATE "default" NOT NULL,
		"codigos" varchar(256) COLLATE "default",
		"precio" varchar(30) COLLATE "default",
		"rural" varchar(3) COLLATE "default",
		"id_subrrogada_foranea" int4
		)
		WITH (OIDS=FALSE)

		;

		-- ----------------------------
		-- Alter Sequences Owned By 
		-- ----------------------------

		-- ----------------------------
		-- Indexes structure for table migra_prestaciones
		-- ----------------------------
		CREATE INDEX "migra_prestaciones_numero_fila_idx" ON "public"."migra_prestaciones" USING btree (numero_fila);

		-- ----------------------------
		-- Primary Key structure for table migra_prestaciones
		-- ----------------------------
		ALTER TABLE "public"."migra_prestaciones" ADD PRIMARY KEY ("id");
    SQL
    ActiveRecord::Base.connection.execute <<-SQL 
		CREATE TABLE IF NOT EXISTS "public"."migra_modulos" (
		"id" int4 NOT NULL,
		"numero_fila" int4,
		"numero_columna_si_no" int4,
		"grupo" int4,
		"subgrupo" varchar(100),
		"modulo" text,
		"definicion_cirugia_conceptos" text,
		"codigos" varchar(256),
		"id_subrrogada_foranea" int4,
		PRIMARY KEY ("id")
		)
		WITH (OIDS=FALSE)
		;

		CREATE UNIQUE INDEX  ON "public"."migra_modulos" ("id");

		CREATE INDEX  ON "public"."migra_modulos" ("numero_fila");
    SQL

    ActiveRecord::Base.connection.execute <<-SQL 
		CREATE TABLE IF NOT EXISTS "public"."migra_anexos"  (
		"id" int4 NOT NULL,
		"numero_fila" int4,
		"numero_columna_si_no" int4,
		"prestaciones" varchar(256),
		"anexo" varchar(500),
		"codigo" varchar(256),
		"precio" varchar(50),
		"rural" varchar(3),
		"id_subrrogada_foranea" int4,
		PRIMARY KEY ("id")
		)
		WITH (OIDS=FALSE)
		;

		CREATE UNIQUE INDEX  ON "public"."migra_anexos" ("id");

		CREATE INDEX  ON "public"."migra_anexos" ("numero_fila");
		SQL
  	
  end

  def self.dropear_tablas
  	ActiveRecord::Base.connection.execute <<-SQL 
  		DROP TABLE IF EXISTS "public"."migra_prestaciones";
  		DROP TABLE IF EXISTS "public"."migra_modulos";
  		DROP TABLE IF EXISTS "public"."migra_anexos";
  	SQL
  end
	
  def prueba
  	book = Spreadsheet.open @rutayarchivo
  	sheet = book.worksheet 0
  	 sheet.each do |row| puts row[0] end
  	
  end

  def filacolumna
  	book = Spreadsheet.open @rutayarchivo
  	sheet = book.worksheet 0

  	puts "fila 236"
  	fila = sheet.row(236)
  	puts "el si/no 13 '#{fila[14]}'"
  	puts "el si/no 13 '#{fila[13]}'"
  	puts "el si/no 12 '#{fila[12]}'"
  	puts "el si/no 11 '#{fila[11]}'"
  	puts " ------"
  	puts "fila 238"
  	fila = sheet.row(236)
  	puts "el si/no 13 '#{fila[14]}'"
  	puts "el si/no 13 '#{fila[13]}'"
  	puts "el si/no 12 '#{fila[12]}'"
  	puts "el si/no 11 '#{fila[11]}'"
  	puts " ------"
  	puts "fila 238"
  	fila = sheet.row(238)
  	puts "el si/no 13 '#{fila[14]}'"
  	puts "el si/no 13 '#{fila[13]}'"
  	puts "el si/no 12 '#{fila[12]}'"
  	puts "el si/no 11 '#{fila[11]}'"

  end
end