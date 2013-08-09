# -*- encoding : utf-8 -*-
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
  # a = MigraConvenios.new('/home/pablo/Documents/Aptana Studio 3 Workspace/nacer/lib/tasks/template ids.xls')
  # a.hoja = 1
  #
  def crear_convenio(convenio)
     
    # Micro Hospital Puente de Hierro 
    # efe = Efector.find(2)
    # conv = ConvenioDeGestionSumar.new ({ 
    #       :numero => 'G-001-025', 
    #       :firmante =>'DRA. ALICIA PAEZ',
    #       :fecha_de_suscripcion => fechasu,
    #       :fecha_de_inicio =>  '01/04/2013',
    #       :efector_id => efe.id}
    #   )
    # conv.save
    # 
    fechasu = Date.new(2013,5,1)

    # Hospital Ministro Dr. Ramón Cariillo
    efe = Efector.find(377)
    conv = ConvenioDeGestionSumar.new ({ 
          :numero => 'G-001-004', 
          :firmante =>'DR. JUAN PABLO RODRIGUEZ',
          :fecha_de_suscripcion => fechasu,
          :fecha_de_inicio =>  fechasu,
          :efector_id => efe.id}
      )
    conv.save

    # Hospital Luis Lagomaggiore 
    efe = Efector.find(45)
    conv = ConvenioDeGestionSumar.new ({ 
          :numero => 'G-001-007', 
          :firmante =>'DR. JOSÉ EDGARDO PEREZ MOYANO',
          :fecha_de_suscripcion => fechasu,
          :fecha_de_inicio =>  fechasu,
          :efector_id => efe.id}
      )
    conv.save

    # Hospital Gailhac
    efe = Efector.find(16)
    conv = ConvenioDeGestionSumar.new ({ 
          :numero => 'G-001-009', 
          :firmante =>'DR. MARCELO R. BARCENILLA',
          :fecha_de_suscripcion => fechasu,
          :fecha_de_inicio =>  fechasu,
          :efector_id => efe.id}
      )
    conv.save

    # Hospital General Las Heras
    efe = Efector.find(301)
    conv = ConvenioDeGestionSumar.new ({ 
          :numero => 'G-001-010', 
          :firmante =>'DR. PABLO ALVAREZ',
          :fecha_de_suscripcion => fechasu,
          :fecha_de_inicio =>  fechasu,
          :efector_id => efe.id}
      )
    conv.save

    # Hospital Enfermeros Argentinos
    efe = Efector.find(96)
    conv = ConvenioDeGestionSumar.new ({ 
          :numero => 'G-001-014', 
          :firmante =>'Dr. ROBERTO WALTER VITALI',
          :fecha_de_suscripcion => fechasu,
          :fecha_de_inicio =>  fechasu,
          :efector_id => efe.id}
      )
    conv.save

    # Hospital EVA PERON
    efe = Efector.find(70)
    conv = ConvenioDeGestionSumar.new ({ 
          :numero => 'G-001-022', 
          :firmante =>'DR. JUAN CARLOS MARTINEZ',
          :fecha_de_suscripcion => fechasu,
          :fecha_de_inicio =>  fechasu,
          :efector_id => efe.id}
      )
    conv.save

    # HOSPITAL  ARTURO  ILLIA - LA PAZ
    efe = Efector.find(114)
    conv = ConvenioDeGestionSumar.new ({ 
          :numero => 'G-001-021', 
          :firmante =>'DESCONOCIDO',
          :fecha_de_suscripcion => fechasu,
          :fecha_de_inicio =>  fechasu,
          :efector_id => efe.id}
      )
    conv.save

    # "Hospital El Sauce"
    efe = Efector.find(69)
    conv = ConvenioDeGestionSumar.new ({ 
          :numero => 'G-001-024', 
          :firmante =>'DRA. MARÍA PATRICIA GORRA',
          :fecha_de_suscripcion => fechasu,
          :fecha_de_inicio =>  fechasu,
          :efector_id => efe.id}
      )
    conv.save

    # Hospital Domingo Sicoli
    efe = Efector.find(148)
    conv = ConvenioDeGestionSumar.new ({ 
          :numero => 'G-001-015', 
          :firmante =>'Dr. Marcelo Fabian Puentes Orellano',
          :fecha_de_suscripcion => fechasu,
          :fecha_de_inicio =>  fechasu,
          :efector_id => efe.id}
      )
    conv.save

    # "Hospital Alfredo Metraux"
    efe = Efector.find(275)
    conv = ConvenioDeGestionSumar.new ({ 
          :numero => 'G-001-023', 
          :firmante =>'Dra. Iris Noemi Agüero',
          :fecha_de_suscripcion => fechasu,
          :fecha_de_inicio =>  fechasu,
          :efector_id => efe.id}
      )
    conv.save

    # Hospital Fernando Arenas Raffo
    efe = Efector.find(282)
    conv = ConvenioDeGestionSumar.new ({ 
          :numero => 'G-001-018', 
          :firmante =>'DESCONOCIDO',
          :fecha_de_suscripcion => fechasu,
          :fecha_de_inicio =>  fechasu,
          :efector_id => efe.id}
      )
    conv.save

    # "Hospital Luis Chrabalowski"
    efe = Efector.find(121)
    conv = ConvenioDeGestionSumar.new ({ 
          :numero => 'G-001-016', 
          :firmante =>'Dra. Iris Isabel Gonzalez de Peralta',
          :fecha_de_suscripcion => fechasu,
          :fecha_de_inicio =>  fechasu,
          :efector_id => efe.id}
      )
    conv.save

    # Hospital Humberto J. Notti
    efe = Efector.find(30)
    conv = ConvenioDeGestionSumar.new ({ 
          :numero => 'G-001-008', 
          :firmante =>'DRA. ANGELA MARÍA INÉS GALLARDO',
          :fecha_de_suscripcion => fechasu,
          :fecha_de_inicio =>  fechasu,
          :efector_id => efe.id}
      )
    conv.save

    # CENTRO SANITARIO VACUNATORIO CENTRAL
    # efe = Efector.find(354)
    # conv = ConvenioDeGestionSumar.new ({ 
    #       :numero => 'G-001-026', 
    #       :firmante =>'DESCONOCIDO',
    #       :fecha_de_suscripcion => fechasu,
     #     :fecha_de_inicio =>  fechasu,
    #       :fecha_de_inicio =>  '01/04/2013',
    #       :efector_id => efe.id}
    #   )
    # conv.save

    # Hospital Carlos F. Saporiti
    efe = Efector.find(173)
    conv = ConvenioDeGestionSumar.new ({ 
          :numero => 'G-001-017', 
          :firmante =>'DR. DANIEL ALBERTO CHAVEZ',
          :fecha_de_suscripcion => fechasu,
          :fecha_de_inicio =>  fechasu,
          :efector_id => efe.id}
      )
    conv.save

    # HOSPITAL MALARGUE 
    efe = Efector.find(197)
    conv = ConvenioDeGestionSumar.new ({ 
          :numero => 'G-001-019', 
          :firmante =>'DR. GENARO RAFAEL GERBAUDO',
          :fecha_de_suscripcion => fechasu,
          :fecha_de_inicio =>  fechasu,
          :efector_id => efe.id}
      )
    conv.save

    # AREA SANITARIA LAS HERAS
    # efe = Efector.find(343)
    # conv = ConvenioDeGestionSumar.new ({ 
    #       :numero => 'G-001-027', 
    #       :firmante =>'Dr. GUSTAVO DANIEL MUSRI',
    #       :fecha_de_suscripcion => fechasu,
     #       :fecha_de_inicio =>  '01/04/2013',
    #       :efector_id => efe.id}
    #   )
    # conv.save

    # Centro de Salud Nº 300 Dr. Arturo Oñativia
    # efe = Efector.find(44)
    # conv = ConvenioDeGestionSumar.new ({ 
    #       :numero => 'G-001-150', 
    #       :firmante =>'DESCONOCIDO',
    #       :fecha_de_suscripcion => fechasu,
     #       :fecha_de_inicio =>  '01/04/2013',
    #       :efector_id => efe.id}
    #   )
    # conv.save

    # # Centro de Salud Nº 301 Dr. Arturo Illia
    # efe = Efector.find(4)
    # conv = ConvenioDeGestionSumar.new ({ 
    #       :numero => 'G-001-151', 
    #       :firmante =>'DESCONOCIDO',
    #       :fecha_de_suscripcion => fechasu,
     #       :fecha_de_inicio =>  '01/04/2013',
    #       :efector_id => efe.id}
    #   )
    # conv.save

    # # Centro de Salud Nº 302 Padre Llorens
    # efe = Efector.find(11)
    # conv = ConvenioDeGestionSumar.new ({ 
    #       :numero => 'G-001-152', 
    #       :firmante =>'DESCONOCIDO',
    #       :fecha_de_suscripcion => fechasu,
     #       :fecha_de_inicio =>  '01/04/2013',
    #       :efector_id => efe.id}
    #   )
    # conv.save

    # # Centro de Salud Nº 367 Bº Andino
    # efe = Efector.find(325)
    # conv = ConvenioDeGestionSumar.new ({ 
    #       :numero => 'G-001-153', 
    #       :firmante =>'DESCONOCIDO',
    #       :fecha_de_suscripcion => fechasu,
     #       :fecha_de_inicio =>  '01/04/2013',
    #       :efector_id => efe.id}
    #   )
    # conv.save

    # # Area Sanitaria Capital 
    # efe = Efector.find(337)
    # conv = ConvenioDeGestionSumar.new ({ 
    #       :numero => 'G-001-122', 
    #       :firmante =>'DESCONOCIDO',
    #       :fecha_de_suscripcion => fechasu,
     #       :fecha_de_inicio =>  '01/04/2013',
    #       :efector_id => efe.id}
    #   )
    # conv.save

    # # CIC (Centro Integrador Comunitario) Nº1
    # efe = Efector.find(363)
    # conv = ConvenioDeGestionSumar.new ({ 
    #       :numero => 'G-001-154', 
    #       :firmante =>'DESCONOCIDO',
    #       :fecha_de_suscripcion => fechasu,
     #       :fecha_de_inicio =>  '01/04/2013',
    #       :efector_id => efe.id}
    #   )
    # conv.save

    # # Centro de Salud nº 1
    # efe = Efector.find(43)
    # conv = ConvenioDeGestionSumar.new ({ 
    #       :numero => 'G-001-123', 
    #       :firmante =>'DESCONOCIDO',
    #       :fecha_de_suscripcion => fechasu,
     #       :fecha_de_inicio =>  '01/04/2013',
    #       :efector_id => efe.id}
    #   )
    # conv.save

    # # Centro de Salud nº 2
    # efe = Efector.find(18)
    # conv = ConvenioDeGestionSumar.new ({ 
    #       :numero => 'G-001-124', 
    #       :firmante =>'Dr. RODOLFO JOSE TORRE F.',
    #       :fecha_de_suscripcion => fechasu,
     #       :fecha_de_inicio =>  '01/04/2013',
    #       :efector_id => efe.id}
    #   )
    # conv.save

    # # CENTRO DE SALUD Nº62 "DR.OSCAR DE LELLIS" 03140
    # efe = Efector.find(56)
    # conv = ConvenioDeGestionSumar.new ({ 
    #       :numero => 'G-001-055', 
    #       :firmante =>'Dra.SEÑIO MONICA BEATRIZ',
    #       :fecha_de_suscripcion => fechasu,
     #       :fecha_de_inicio =>  '01/04/2013',
    #       :efector_id => efe.id}
    #   )
    # conv.save

    # #CENTRO DE SALUD Nº 17 "CARLOS EVANS"
    # efe = Efector.find(32)
    # conv = ConvenioDeGestionSumar.new ({ 
    #       :numero => 'G-001-036', 
    #       :firmante =>'DESCONOCIDO',
    #       :fecha_de_suscripcion => fechasu,
     #       :fecha_de_inicio =>  '01/04/2013',
    #       :efector_id => efe.id}
    #   )
    # conv.save
    
    # Hospital Diego Paroissien 
    efe = Efector.find(42)
    conv = ConvenioDeGestionSumar.new ({ 
          :numero => 'G-001-003', 
          :firmante =>'Dr. Luis Jofre',
          :fecha_de_suscripcion => fechasu,
          :fecha_de_inicio =>  fechasu,
           :efector_id => efe.id}
      )
    conv.save

    #"Hospital Dr. Alfredo Italo Perrupato"
    efe = Efector.find(263)
    conv = ConvenioDeGestionSumar.new ({ 
          :numero => 'G-001-012', 
          :firmante =>'DR. GUSTAVO GUILLERMO PATTI',
          :fecha_de_suscripcion => fechasu,
          :fecha_de_inicio =>  fechasu,
          :efector_id => efe.id}
      )
    conv.save

    #"Hospital Teodoro Schestakow
    efe = Efector.find(53)
    conv = ConvenioDeGestionSumar.new ({ 
          :numero => 'G-001-006', 
          :firmante =>'Dr. Armando I. Dauverne',
          :fecha_de_suscripcion => fechasu,
          :fecha_de_inicio =>  fechasu,
          :efector_id => efe.id}
      )
    conv.save















  	# TODO: AMAR INSERT A LA TABLA DE CONVENIOS
  	# algo como:
  	# @convenio = ConvenioDeGestion.new({muchos_parametros: 'a', .....})
  	# @convenio = convenio
  	# @convenio.save
  end

  def actualiza_plantilla
    ActiveRecord::Base.connection.schema_search_path = "public"
    
    ActiveRecord::Base.transaction do
      book = Spreadsheet.open @rutayarchivo
      sheet = book.worksheet @hoja
      sheet.each 5 do |row| 




    end


    end
  end


  def initialize(args)
	@rutayarchivo = args
	#@book = Spreadsheet.open @rutayarchivo
  	#@sheet = book.worksheet 1
  end
	


  def cargar_datos
    ActiveRecord::Base.connection.schema_search_path = "public"
    ActiveRecord::Base.transaction do

    book = Spreadsheet.open @rutayarchivo
  	sheet = book.worksheet @hoja
  	id=0

  	#Cargo la seccion 1 - 1.1
  	sheet.each 43 do |row| 

      if row[14].to_s.match /p/
        row[14].split('p').each do | ids |
          ActiveRecord::Base.connection.execute "
            INSERT INTO migra_prestaciones 
              ( id ,  numero_fila ,  numero_columna_si_no ,  grupo ,  subgrupo ,  nosologia  ,  tipo_de_prestacion ,  nombre_prestacion ,  codigos                 ,  precio   ,  rural ,id_subrrogada_foranea)  
              VALUES                                   
              (#{id}, #{row.idx+1} , 13                    , '1'    ,      '1.1',    '#{row[0]}',            '#{row[1]}',           '#{row[2]}', '#{row[8] + ' ' + row[10]}', '#{row[11]}', '#{row[12]}', #{ids});"
            id+=1
            if (row.idx+1) == 95
              break
            end
        end
      else

    	  ActiveRecord::Base.connection.execute "
    	 	INSERT INTO migra_prestaciones 
    	 	  ( id ,  numero_fila ,  numero_columna_si_no ,  grupo ,  subgrupo ,  nosologia  ,  tipo_de_prestacion ,  nombre_prestacion ,  codigos                 ,  precio   ,  rural ,id_subrrogada_foranea)  
    	 	  VALUES                                   
    	 	  (#{id}, #{row.idx+1} , 13                    , '1'    ,      '1.1',    '#{row[0]}',            '#{row[1]}',           '#{row[2]}', '#{row[8] + ' ' + row[10]}', '#{row[11]}', '#{row[12]}', '#{row[14]}');"
    	 	id+=1
    	 	if (row.idx+1) == 95
    	 		break
    	 	end
     end
  	end

  	#Cargo la seccion 1 - 1.2-A
  	sheet.each 99 do |row| 
  	  ActiveRecord::Base.connection.execute "
  	 	INSERT INTO migra_prestaciones 
  	 	  ( id ,  numero_fila ,  numero_columna_si_no ,  grupo ,  subgrupo ,  nosologia  ,  tipo_de_prestacion ,  nombre_prestacion ,  codigos                 ,  precio   ,  rural ,id_subrrogada_foranea)    
  	 	  VALUES                                   
  	 	  (#{id}, #{row.idx+1} , 13                    , '1'    ,      '1.2-a',    '#{row[0]}',            '#{row[1]}',           '#{row[2]}', '#{row[8] + ' ' + row[10]}', '#{row[11]}', '#{row[12]}', '#{row[14]}');"
  	 	id+=1
  	 	if (row.idx+1) == 162
  	 		break
  	 	end
  	end
  
  	#Cargo la seccion 2 - 2.1
  	sheet.each 190 do |row| 
      if row[14].to_s.match /p/
        row[14].split('p').each do | ids |
          ActiveRecord::Base.connection.execute "
          INSERT INTO migra_prestaciones 
            ( id ,  numero_fila ,  numero_columna_si_no ,  grupo ,  subgrupo ,  nosologia  ,  tipo_de_prestacion ,  nombre_prestacion ,  codigos                 ,  precio   ,  rural ,id_subrrogada_foranea)    
            VALUES                                   
            (#{id}, #{row.idx+1} , 13                    , '2'    ,      '2.1',    '#{row[0]}',            '#{row[1]}',           '#{row[2]}', '#{row[8] + ' ' + row[10]}', '#{row[11]}', '#{row[12]}', '#{ids}');"
          id+=1
          if (row.idx+1) == 200
            break
          end
        end
      else
    	  ActiveRecord::Base.connection.execute "
    	 	INSERT INTO migra_prestaciones 
    	 	  ( id ,  numero_fila ,  numero_columna_si_no ,  grupo ,  subgrupo ,  nosologia  ,  tipo_de_prestacion ,  nombre_prestacion ,  codigos                 ,  precio   ,  rural ,id_subrrogada_foranea)    
    	 	  VALUES                                   
    	 	  (#{id}, #{row.idx+1} , 13                    , '2'    ,      '2.1',    '#{row[0]}',            '#{row[1]}',           '#{row[2]}', '#{row[8] + ' ' + row[10]}', '#{row[11]}', '#{row[12]}', '#{row[14]}');"
    	 	id+=1
    	 	if (row.idx+1) == 200
    	 		break
    	 	end
      end
  	end

  	#Cargo la seccion 2 - 2.5
  	sheet.each 226 do |row| 
  	  ActiveRecord::Base.connection.execute "
  	 	INSERT INTO migra_prestaciones 
  	 	  ( id ,  numero_fila ,  numero_columna_si_no ,  grupo ,  subgrupo ,  nosologia  ,  tipo_de_prestacion ,  nombre_prestacion ,  codigos                 ,  precio   ,  rural ,id_subrrogada_foranea)    
  	 	  VALUES                                   
  	 	  (#{id}, #{row.idx+1} , 13                    , '2'    ,      '2.5', '#{row[0]}',          '#{row[1]}',         '#{row[2]}', '#{row[8]}', '#{row[11]}', '#{row[12]}', '#{row[14]}');"
  	 	id+=1
  	 	if (row.idx+1) == 232
  	 		break
  	 	end
  	end

  	#Cargo la seccion 2 - 2.7
  	sheet.each 280 do |row| 
  	  ActiveRecord::Base.connection.execute "
  	 	INSERT INTO migra_prestaciones 
  	 	  ( id ,  numero_fila ,  numero_columna_si_no ,  grupo ,  subgrupo ,  nosologia  ,  tipo_de_prestacion ,  nombre_prestacion ,  codigos                 ,  precio   ,  rural ,id_subrrogada_foranea)    
  	 	  VALUES                                   
  	 	  (#{id}, #{row.idx+1} , 13                    , '2'    ,      '2.7',    '#{row[0]}',            '#{row[1]}',           '#{row[2]}', '#{row[8] + ' ' + row[10]}', '#{row[11]}', '#{row[12]}', '#{row[14]}');"
  	 	id+=1
  	 	if (row.idx+1) == 326
  	 		break
  	 	end
  	end

  	#Cargo la seccion 3 - 3.1
  	sheet.each 332 do |row| 
  	  ActiveRecord::Base.connection.execute "
  	 	INSERT INTO migra_prestaciones 
  	 	  ( id ,  numero_fila ,  numero_columna_si_no ,  grupo ,  subgrupo ,  nosologia  ,  tipo_de_prestacion ,  nombre_prestacion ,  codigos                 ,  precio   ,  rural ,id_subrrogada_foranea)    
  	 	  VALUES                                   
  	 	  (#{id}, #{row.idx+1} , 13                    , '3'    ,      '3.1',    '#{row[0]}',            '#{row[1]}',           '#{row[2]}', '#{row[8] + ' ' + row[10]}', '#{row[11]}', '#{row[12]}', '#{row[14]}');"
  	 	id+=1
  	 	if (row.idx+1) == 367
  	 		break
  	 	end
  	end

  	#Cargo la seccion 4 - 4.1
  	sheet.each 374 do |row| 
  	  ActiveRecord::Base.connection.execute "
  	 	INSERT INTO migra_prestaciones 
  	 	  ( id ,  numero_fila ,  numero_columna_si_no ,  grupo ,  subgrupo ,  nosologia  ,  tipo_de_prestacion ,  nombre_prestacion ,  codigos                 ,  precio   ,  rural ,id_subrrogada_foranea)    
  	 	  VALUES                                   
  	 	  (#{id}, #{row.idx+1} , 13                    , '4'    ,      '4.1',    '#{row[0]}',            '#{row[1]}',           '#{row[2]}', '#{row[8] + ' ' + row[10]}', '#{row[11]}', '#{row[12]}', '#{row[14]}');"
  	 	id+=1
  	 	if (row.idx+1) == 428
  	 		break
  	 	end
  	end

  	#Cargo la seccion 5 - 5.1
  	sheet.each 435 do |row| 
  	  ActiveRecord::Base.connection.execute "
  	 	INSERT INTO migra_prestaciones 
  	 	  ( id ,  numero_fila ,  numero_columna_si_no ,  grupo ,  subgrupo ,  nosologia  ,  tipo_de_prestacion ,  nombre_prestacion ,  codigos                 ,  precio   ,  rural ,id_subrrogada_foranea)    
  	 	  VALUES                                   
  	 	  (#{id}, #{row.idx+1} , 13                    , '5'    ,      '5.1',    '#{row[0]}',            '#{row[1]}',           '#{row[2]}', '#{row[8] + ' ' + row[10]}', '#{row[11]}', '#{row[12]}', '#{row[14]}');"
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
	    ( id   ,  numero_fila ,  numero_columna_si_no ,  grupo ,  subgrupo ,   modulo ,  definicion_cirugia_conceptos ,  codigos, id_subrrogada_foranea ) 
	    VALUES 
	    (#{idm},#{row.idx+1}  , 13                    , '1'    , '1.2-B'   , '#{row[2]}',                            NULL, '#{row[7]}','#{row[14]}' );"
      idm+=1
  	   if (row.idx+1) == 173
  	     break
  	   end
  	end

  	#Cargo la seccion 1 - 1.2-C
  	sheet.each 177 do |row| 
	  ActiveRecord::Base.connection.execute "
	    INSERT INTO migra_modulos 
	    ( id   ,  numero_fila ,  numero_columna_si_no ,  grupo ,  subgrupo ,   modulo ,  definicion_cirugia_conceptos ,  codigos, id_subrrogada_foranea ) 
	    VALUES 
	    (#{idm},#{row.idx+1}  , 11                    , '1'    , '1.2-C'   , '#{row[2]}',                            NULL, '#{row[7]}','#{row[12]}' );"
      idm+=1
  	   if (row.idx+1) == 180
  	     break
  	   end
  	end

  	#Cargo la seccion 1 - 1.2-D
  	sheet.each 184 do |row| 
	  ActiveRecord::Base.connection.execute "
	    INSERT INTO migra_modulos 
	    ( id   ,  numero_fila ,  numero_columna_si_no ,  grupo ,  subgrupo ,   modulo ,  definicion_cirugia_conceptos ,  codigos, id_subrrogada_foranea ) 
	    VALUES 
	    (#{idm},#{row.idx+1}  , 11                    , '1'    , '1.2-D'   , '#{row[0]}',                            NULL, '#{row[8]}' ,'#{row[12]}');"
      idm+=1
  	   if (row.idx+1) == 185
  	     break
  	   end
  	end

  	#Cargo la seccion 2 - 2.2
  	sheet.each 204 do |row| 
	  ActiveRecord::Base.connection.execute "
	  INSERT INTO migra_modulos 
	    ( id   ,  numero_fila ,  numero_columna_si_no ,  grupo ,  subgrupo ,   modulo ,  definicion_cirugia_conceptos ,  codigos, id_subrrogada_foranea ) 
	    VALUES 
	    (#{idm},#{row.idx+1}  , 13                    , '2'    , '2.2'     , '#{row[1]}',                      '#{row[2]}', '#{row[0]}','#{row[14]}' );"
      idm+=1
  	   if (row.idx+1) == 207
  	     break
  	   end
  	end

  	#Cargo la seccion 2 - 2.3
  	sheet.each 211 do |row| 
	  ActiveRecord::Base.connection.execute "INSERT INTO migra_modulos 
	    ( id   ,  numero_fila ,  numero_columna_si_no ,  grupo ,  subgrupo ,   modulo ,  definicion_cirugia_conceptos ,  codigos, id_subrrogada_foranea ) 
	    VALUES 
	    (#{idm},#{row.idx+1}  , 11                    , '2'    , '2.3'     , '#{row[2]}',                      NULL, '#{row[8]}','#{row[12]}' );"
      idm+=1
  	   if (row.idx+1) == 213
  	     break
  	   end
  	end


  	#Cargo la seccion 2 - 2.4
  	sheet.each 217 do |row| 
	  ActiveRecord::Base.connection.execute "
	    INSERT INTO migra_modulos 
	    ( id   ,  numero_fila ,  numero_columna_si_no ,  grupo ,  subgrupo ,   modulo ,  definicion_cirugia_conceptos ,  codigos, id_subrrogada_foranea ) 
	    VALUES 
	    (#{idm},#{row.idx+1}  , 11                    , '2'    , '2.4'     , '#{row[2]}',                      NULL, '#{row[8]}' ,'#{row[12]}');"
      idm+=1
  	   if (row.idx+1) == 218
  	     break
  	   end
  	end

  	#Cargo la seccion 2 - 2.6
	sheet.each 236 do |row| 
	  ActiveRecord::Base.connection.execute "
	    INSERT INTO migra_modulos 
	    ( id   ,  numero_fila ,  numero_columna_si_no ,  grupo ,  subgrupo ,   modulo ,  definicion_cirugia_conceptos ,  codigos, id_subrrogada_foranea ) 
	    VALUES 
	    (#{idm},#{row.idx+1}  , 13                    , '2'    , '2.6'     , '#{row[0]}',                      '#{row[1]}', '#{row[3]}','#{row[14]}' );"
      idm+=1
  	   if (row.idx+1) == 246
  	     break
  	   end
  	end

	sheet.each 249 do |row| 
	  ActiveRecord::Base.connection.execute "
	    INSERT INTO migra_modulos 
	    ( id   ,  numero_fila ,  numero_columna_si_no ,  grupo ,  subgrupo ,   modulo ,  definicion_cirugia_conceptos ,  codigos, id_subrrogada_foranea ) 
	    VALUES 
	    (#{idm},#{row.idx+1}  , 13                    , '2'    , '2.6'     , '#{row[0]}',                      '#{row[1]}', '#{row[3]}','#{row[14]}' );"
      idm+=1
  	   if (row.idx+1) == 253
  	     break
  	   end
  	end

  	sheet.each 255 do |row| 
	  ActiveRecord::Base.connection.execute "
	    INSERT INTO migra_modulos 
	    ( id   ,  numero_fila ,  numero_columna_si_no ,  grupo ,  subgrupo ,   modulo ,  definicion_cirugia_conceptos ,  codigos, id_subrrogada_foranea ) 
	    VALUES 
	    (#{idm},#{row.idx+1}  , 13                    , '2'    , '2.6'     , '#{row[0]}',                      '#{row[1]}', '#{row[3]}' ,'#{row[14]}');"
      idm+=1
  	   if (row.idx+1) == 260
  	     break
  	   end
  	end

  	sheet.each 262 do |row| 
	  ActiveRecord::Base.connection.execute "
	  INSERT INTO migra_modulos 
	    ( id   ,  numero_fila ,  numero_columna_si_no ,  grupo ,  subgrupo ,   modulo ,  definicion_cirugia_conceptos ,  codigos, id_subrrogada_foranea ) 
	    VALUES 
	    (#{idm},#{row.idx+1}  , 13                    , '2'    , '2.6'     , '#{row[0]}',                      '#{row[1]}', '#{row[3]}','#{row[14]}' );"
      idm+=1
  	   if (row.idx+1) == 263
  	     break
  	   end
  	end

  	#Cargo la seccion 2 - 2.7
  	sheet.each 267 do |row| 
	  ActiveRecord::Base.connection.execute "
	  INSERT INTO migra_modulos 
	    ( id   ,  numero_fila ,  numero_columna_si_no ,  grupo ,  subgrupo ,   modulo ,  definicion_cirugia_conceptos ,  codigos, id_subrrogada_foranea ) 
	    VALUES 
	    (#{idm},#{row.idx+1}  , 13                    , '2'    , '2.7'     , '#{row[0]}',                      '#{row[5]}', '#{row[3]}','#{row[14]}' );"
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

    ActiveRecord::Base.connection.execute "
      DELETE FROM migra_prestaciones WHERE id_subrrogada_foranea = -1;
      DELETE FROM migra_modulos WHERE id_subrrogada_foranea = -1;
      "
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

  def self.crear_convenios_prestaciones
    ruta = 'lib/tasks/archproc/'
    archivos = ['HOSPITAL CARRILLO final-des.xls',
      'PlandeServdeSalud_Env a UEC_UltVer_May13 LAGO FINAL-des.xls',
      'PlandeServdeSalud_Env a UEC_UltVer_May13 NOTTI FINAL-des.xls',
      'PlandeServdeSalud_Env a UEC_UltVer_May13 PAROISSIEN-des.xls',
      'PlandeServdeSalud_Env a UEC_UltVer_May13 PERRUPATO-des.xls',
      'PlandeServdeSalud_Env a UEC_UltVer_May13 Schestakow-des.xls',
      'PlandeServdeSalud Gailhac FINAL-des.xls',
      'PlandeServdeSalud hospital LAS HERAS FINAL-des.xls',
      'PlandeServdeSalud_May13 FINAL-des.xls',
      'PlandeServdeSalud_May13 ok Hptal EVA PERON-des.xls',
      'Plan deServdeSalud sumar.ILLIA Final-des.xls',
      'Plan de Servicio_El Sauce ro-des.xls',
      'Plan de Servicios de Salud Mayo 2013saporit-des.xls',
      'PLAN DE SERVICIOS DE SALUD SICOLI FINAL-des.xls',
      'PLAN SUMAR HOSPITAL MALARGUE final-des.xls',
      'SERVICIO SALUD SUMAR final-des.xls',
      'SUMAR Raffo Final-des.xls']


  

    ActiveRecord::Base.connection.schema_search_path = "public"
    archivos.each do |ra|
      @rutayarchivo = ruta + ra
      ActiveRecord::Base.transaction do

        book = Spreadsheet.open @rutayarchivo
        sheet = book.worksheet 0
        id=0

        convenio = ConvenioDeGestionSumar.find_by_numero!(sheet.row(34)[5])

        #Cargo la seccion 1 - 1.1
        sheet.each 43 do |row|
          if row[13].to_s.match /s/i
            insert_ids = ActiveRecord::Base.connection.exec_query("
              SELECT id_subrrogada_foranea FROM migra_prestaciones WHERE numero_fila = #{row.idx+1};
              ").rows.collect{|r| r[0]}

            insert_ids.each do |prestacion_id|
              pa = PrestacionAutorizada.create!({
                :efector_id => convenio.efector.id,
                :prestacion_id => prestacion_id,
                :fecha_de_inicio => convenio.fecha_de_inicio,
                :autorizante_al_alta_id => convenio.id,
                :autorizante_al_alta_type => 'ConvenioDeGestionSumar',
                :creator_id => 1,
                :updater_id => 1
                })
            end
          end

          if (row.idx+1) == 95
            break
          end

        end

        #Cargo la seccion 1 - 1.2-A
        sheet.each 99 do |row| 
          if row[13].to_s.match /s/i
            insert_ids = ActiveRecord::Base.connection.exec_query("
              SELECT id_subrrogada_foranea FROM migra_prestaciones WHERE numero_fila = #{row.idx+1};
              ").rows.collect{|r| r[0]}

            insert_ids.each do |prestacion_id|
              if !(PrestacionAutorizada.where({:efector_id => convenio.efector.id, :prestacion_id => prestacion_id, :fecha_de_finalizacion => nil}).first)
                pa = PrestacionAutorizada.create!({
                  :efector_id => convenio.efector.id,
                  :prestacion_id => prestacion_id,
                  :fecha_de_inicio => convenio.fecha_de_inicio,
                  :autorizante_al_alta_id => convenio.id,
                  :autorizante_al_alta_type => 'ConvenioDeGestionSumar',
                  :creator_id => 1,
                  :updater_id => 1
                  })
              end
            end
          end

          if (row.idx+1) == 162
            break
          end
        end
      
        #Cargo la seccion 2 - 2.1
        sheet.each 190 do |row| 
          if row[13].to_s.match /s/i
            insert_ids = ActiveRecord::Base.connection.exec_query("
              SELECT id_subrrogada_foranea FROM migra_prestaciones WHERE numero_fila = #{row.idx+1};
              ").rows.collect{|r| r[0]}

            insert_ids.each do |prestacion_id|
              if !(PrestacionAutorizada.where({:efector_id => convenio.efector.id, :prestacion_id => prestacion_id, :fecha_de_finalizacion => nil}).first)
                pa = PrestacionAutorizada.create!({
                  :efector_id => convenio.efector.id,
                  :prestacion_id => prestacion_id,
                  :fecha_de_inicio => convenio.fecha_de_inicio,
                  :autorizante_al_alta_id => convenio.id,
                  :autorizante_al_alta_type => 'ConvenioDeGestionSumar',
                  :creator_id => 1,
                  :updater_id => 1
                  })
              end
            end
          end
          
          if (row.idx+1) == 200
            break
          end
        end

        #Cargo la seccion 2 - 2.5
        sheet.each 226 do |row| 
          if row[13].to_s.match /s/i
            insert_ids = ActiveRecord::Base.connection.exec_query("
              SELECT id_subrrogada_foranea FROM migra_prestaciones WHERE numero_fila = #{row.idx+1};
              ").rows.collect{|r| r[0]}

            insert_ids.each do |prestacion_id|
              if !(PrestacionAutorizada.where({:efector_id => convenio.efector.id, :prestacion_id => prestacion_id, :fecha_de_finalizacion => nil}).first)
                pa = PrestacionAutorizada.create!({
                  :efector_id => convenio.efector.id,
                  :prestacion_id => prestacion_id,
                  :fecha_de_inicio => convenio.fecha_de_inicio,
                  :autorizante_al_alta_id => convenio.id,
                  :autorizante_al_alta_type => 'ConvenioDeGestionSumar',
                  :creator_id => 1,
                  :updater_id => 1
                  })
              end
            end
          end
          
          if (row.idx+1) == 232
            break
          end
        end

        #Cargo la seccion 2 - 2.7
        sheet.each 280 do |row| 
          if row[13].to_s.match /s/i
            insert_ids = ActiveRecord::Base.connection.exec_query("
              SELECT id_subrrogada_foranea FROM migra_prestaciones WHERE numero_fila = #{row.idx+1};
              ").rows.collect{|r| r[0]}

            insert_ids.each do |prestacion_id|
              if !(PrestacionAutorizada.where({:efector_id => convenio.efector.id, :prestacion_id => prestacion_id, :fecha_de_finalizacion => nil}).first)
                pa = PrestacionAutorizada.create!({
                  :efector_id => convenio.efector.id,
                  :prestacion_id => prestacion_id,
                  :fecha_de_inicio => convenio.fecha_de_inicio,
                  :autorizante_al_alta_id => convenio.id,
                  :autorizante_al_alta_type => 'ConvenioDeGestionSumar',
                  :creator_id => 1,
                  :updater_id => 1
                  })
              end
            end
          end
          
          if (row.idx+1) == 326
            break
          end
        end

        #Cargo la seccion 3 - 3.1
        sheet.each 332 do |row| 
          if row[13].to_s.match /s/i
            insert_ids = ActiveRecord::Base.connection.exec_query("
              SELECT id_subrrogada_foranea FROM migra_prestaciones WHERE numero_fila = #{row.idx+1};
              ").rows.collect{|r| r[0]}

            insert_ids.each do |prestacion_id|
              if !(PrestacionAutorizada.where({:efector_id => convenio.efector.id, :prestacion_id => prestacion_id, :fecha_de_finalizacion => nil}).first)
                pa = PrestacionAutorizada.create!({
                  :efector_id => convenio.efector.id,
                  :prestacion_id => prestacion_id,
                  :fecha_de_inicio => convenio.fecha_de_inicio,
                  :autorizante_al_alta_id => convenio.id,
                  :autorizante_al_alta_type => 'ConvenioDeGestionSumar',
                  :creator_id => 1,
                  :updater_id => 1
                  })
              end
            end
          end
          
          if (row.idx+1) == 367
            break
          end
        end

        #Cargo la seccion 4 - 4.1
        sheet.each 374 do |row| 
          if row[13].to_s.match /s/i
            insert_ids = ActiveRecord::Base.connection.exec_query("
              SELECT id_subrrogada_foranea FROM migra_prestaciones WHERE numero_fila = #{row.idx+1};
              ").rows.collect{|r| r[0]}

            insert_ids.each do |prestacion_id|
              if !(PrestacionAutorizada.where({:efector_id => convenio.efector.id, :prestacion_id => prestacion_id, :fecha_de_finalizacion => nil}).first)
                pa = PrestacionAutorizada.create!({
                  :efector_id => convenio.efector.id,
                  :prestacion_id => prestacion_id,
                  :fecha_de_inicio => convenio.fecha_de_inicio,
                  :autorizante_al_alta_id => convenio.id,
                  :autorizante_al_alta_type => 'ConvenioDeGestionSumar',
                  :creator_id => 1,
                  :updater_id => 1
                  })
              end
            end
          end
          
          if (row.idx+1) == 428
            break
          end
        end

        #Cargo la seccion 5 - 5.1
        sheet.each 435 do |row| 
          if row[13].to_s.match /s/i
            insert_ids = ActiveRecord::Base.connection.exec_query("
              SELECT id_subrrogada_foranea FROM migra_prestaciones WHERE numero_fila = #{row.idx+1};
              ").rows.collect{|r| r[0]}

            insert_ids.each do |prestacion_id|
              if !(PrestacionAutorizada.where({:efector_id => convenio.efector.id, :prestacion_id => prestacion_id, :fecha_de_finalizacion => nil}).first)
                pa = PrestacionAutorizada.create!({
                  :efector_id => convenio.efector.id,
                  :prestacion_id => prestacion_id,
                  :fecha_de_inicio => convenio.fecha_de_inicio,
                  :autorizante_al_alta_id => convenio.id,
                  :autorizante_al_alta_type => 'ConvenioDeGestionSumar',
                  :creator_id => 1,
                  :updater_id => 1
                  })
              end
            end
          end
          
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
          if row[13].to_s.match /s/i
            insert_ids = ActiveRecord::Base.connection.exec_query("
              SELECT id_subrrogada_foranea FROM migra_modulos WHERE numero_fila = #{row.idx+1};
              ").rows.collect{|r| r[0]}

            insert_ids.each do |prestacion_id|
              if !(PrestacionAutorizada.where({:efector_id => convenio.efector.id, :prestacion_id => prestacion_id, :fecha_de_finalizacion => nil}).first)
                pa = PrestacionAutorizada.create!({
                  :efector_id => convenio.efector.id,
                  :prestacion_id => prestacion_id,
                  :fecha_de_inicio => convenio.fecha_de_inicio,
                  :autorizante_al_alta_id => convenio.id,
                  :autorizante_al_alta_type => 'ConvenioDeGestionSumar',
                  :creator_id => 1,
                  :updater_id => 1
                  })
              end
            end
          end
          
          if (row.idx+1) == 173
            break
          end
        end

        #Cargo la seccion 1 - 1.2-C
        sheet.each 177 do |row| 
          if row[11].to_s.match /s/i
            insert_ids = ActiveRecord::Base.connection.exec_query("
              SELECT id_subrrogada_foranea FROM migra_modulos WHERE numero_fila = #{row.idx+1};
              ").rows.collect{|r| r[0]}

            insert_ids.each do |prestacion_id|
              if !(PrestacionAutorizada.where({:efector_id => convenio.efector.id, :prestacion_id => prestacion_id, :fecha_de_finalizacion => nil}).first)
                pa = PrestacionAutorizada.create!({
                  :efector_id => convenio.efector.id,
                  :prestacion_id => prestacion_id,
                  :fecha_de_inicio => convenio.fecha_de_inicio,
                  :autorizante_al_alta_id => convenio.id,
                  :autorizante_al_alta_type => 'ConvenioDeGestionSumar',
                  :creator_id => 1,
                  :updater_id => 1
                  })
              end
            end
          end
          
           if (row.idx+1) == 180
             break
           end
        end

        #Cargo la seccion 1 - 1.2-D
        sheet.each 184 do |row| 
          if row[11].to_s.match /s/i
            insert_ids = ActiveRecord::Base.connection.exec_query("
              SELECT id_subrrogada_foranea FROM migra_modulos WHERE numero_fila = #{row.idx+1};
              ").rows.collect{|r| r[0]}

            insert_ids.each do |prestacion_id|
              if !(PrestacionAutorizada.where({:efector_id => convenio.efector.id, :prestacion_id => prestacion_id, :fecha_de_finalizacion => nil}).first)
                pa = PrestacionAutorizada.create!({
                  :efector_id => convenio.efector.id,
                  :prestacion_id => prestacion_id,
                  :fecha_de_inicio => convenio.fecha_de_inicio,
                  :autorizante_al_alta_id => convenio.id,
                  :autorizante_al_alta_type => 'ConvenioDeGestionSumar',
                  :creator_id => 1,
                  :updater_id => 1
                  })
              end
            end
          end
          
           if (row.idx+1) == 185
             break
           end
        end

        #Cargo la seccion 2 - 2.2
        sheet.each 204 do |row| 
          if row[13].to_s.match /s/i
            insert_ids = ActiveRecord::Base.connection.exec_query("
              SELECT id_subrrogada_foranea FROM migra_modulos WHERE numero_fila = #{row.idx+1};
              ").rows.collect{|r| r[0]}

            insert_ids.each do |prestacion_id|
              if !(PrestacionAutorizada.where({:efector_id => convenio.efector.id, :prestacion_id => prestacion_id, :fecha_de_finalizacion => nil}).first)
                pa = PrestacionAutorizada.create!({
                  :efector_id => convenio.efector.id,
                  :prestacion_id => prestacion_id,
                  :fecha_de_inicio => convenio.fecha_de_inicio,
                  :autorizante_al_alta_id => convenio.id,
                  :autorizante_al_alta_type => 'ConvenioDeGestionSumar',
                  :creator_id => 1,
                  :updater_id => 1
                  })
              end
            end
          end
          
           if (row.idx+1) == 207
             break
           end
        end

        #Cargo la seccion 2 - 2.3
        sheet.each 211 do |row| 
          if row[13].to_s.match /s/i
            insert_ids = ActiveRecord::Base.connection.exec_query("
              SELECT id_subrrogada_foranea FROM migra_modulos WHERE numero_fila = #{row.idx+1};
              ").rows.collect{|r| r[0]}

            insert_ids.each do |prestacion_id|
              if !(PrestacionAutorizada.where({:efector_id => convenio.efector.id, :prestacion_id => prestacion_id, :fecha_de_finalizacion => nil}).first)
                pa = PrestacionAutorizada.create!({
                  :efector_id => convenio.efector.id,
                  :prestacion_id => prestacion_id,
                  :fecha_de_inicio => convenio.fecha_de_inicio,
                  :autorizante_al_alta_id => convenio.id,
                  :autorizante_al_alta_type => 'ConvenioDeGestionSumar',
                  :creator_id => 1,
                  :updater_id => 1
                  })
              end
            end
          end
          
           if (row.idx+1) == 213
             break
           end
        end


        #Cargo la seccion 2 - 2.4
        sheet.each 217 do |row| 
          if row[11].to_s.match /s/i
            insert_ids = ActiveRecord::Base.connection.exec_query("
              SELECT id_subrrogada_foranea FROM migra_modulos WHERE numero_fila = #{row.idx+1};
              ").rows.collect{|r| r[0]}

            insert_ids.each do |prestacion_id|
              if !(PrestacionAutorizada.where({:efector_id => convenio.efector.id, :prestacion_id => prestacion_id, :fecha_de_finalizacion => nil}).first)
                pa = PrestacionAutorizada.create!({
                  :efector_id => convenio.efector.id,
                  :prestacion_id => prestacion_id,
                  :fecha_de_inicio => convenio.fecha_de_inicio,
                  :autorizante_al_alta_id => convenio.id,
                  :autorizante_al_alta_type => 'ConvenioDeGestionSumar',
                  :creator_id => 1,
                  :updater_id => 1
                  })
              end
            end
          end
          
           if (row.idx+1) == 218
             break
           end
        end

        #Cargo la seccion 2 - 2.6
        sheet.each 236 do |row| 
          if row[13].to_s.match /s/i
            insert_ids = ActiveRecord::Base.connection.exec_query("
              SELECT id_subrrogada_foranea FROM migra_modulos WHERE numero_fila = #{row.idx+1};
              ").rows.collect{|r| r[0]}

            insert_ids.each do |prestacion_id|
              if !(PrestacionAutorizada.where({:efector_id => convenio.efector.id, :prestacion_id => prestacion_id, :fecha_de_finalizacion => nil}).first)
                pa = PrestacionAutorizada.create!({
                  :efector_id => convenio.efector.id,
                  :prestacion_id => prestacion_id,
                  :fecha_de_inicio => convenio.fecha_de_inicio,
                  :autorizante_al_alta_id => convenio.id,
                  :autorizante_al_alta_type => 'ConvenioDeGestionSumar',
                  :creator_id => 1,
                  :updater_id => 1
                  })
              end
            end
          end
          
           if (row.idx+1) == 246
             break
           end
        end

        sheet.each 249 do |row| 
          if row[13].to_s.match /s/i
            insert_ids = ActiveRecord::Base.connection.exec_query("
              SELECT id_subrrogada_foranea FROM migra_modulos WHERE numero_fila = #{row.idx+1};
              ").rows.collect{|r| r[0]}

            insert_ids.each do |prestacion_id|
              if !(PrestacionAutorizada.where({:efector_id => convenio.efector.id, :prestacion_id => prestacion_id, :fecha_de_finalizacion => nil}).first)
                pa = PrestacionAutorizada.create!({
                  :efector_id => convenio.efector.id,
                  :prestacion_id => prestacion_id,
                  :fecha_de_inicio => convenio.fecha_de_inicio,
                  :autorizante_al_alta_id => convenio.id,
                  :autorizante_al_alta_type => 'ConvenioDeGestionSumar',
                  :creator_id => 1,
                  :updater_id => 1
                  })
              end
            end
          end
          
           if (row.idx+1) == 253
             break
           end
        end

        sheet.each 255 do |row| 
          if row[13].to_s.match /s/i
            insert_ids = ActiveRecord::Base.connection.exec_query("
              SELECT id_subrrogada_foranea FROM migra_modulos WHERE numero_fila = #{row.idx+1};
              ").rows.collect{|r| r[0]}

            insert_ids.each do |prestacion_id|
              if !(PrestacionAutorizada.where({:efector_id => convenio.efector.id, :prestacion_id => prestacion_id, :fecha_de_finalizacion => nil}).first)
                pa = PrestacionAutorizada.create!({
                  :efector_id => convenio.efector.id,
                  :prestacion_id => prestacion_id,
                  :fecha_de_inicio => convenio.fecha_de_inicio,
                  :autorizante_al_alta_id => convenio.id,
                  :autorizante_al_alta_type => 'ConvenioDeGestionSumar',
                  :creator_id => 1,
                  :updater_id => 1
                  })
              end
            end
          end
        
          if (row.idx+1) == 260
            break
          end
        end

        sheet.each 262 do |row| 
          if row[13].to_s.match /s/i
            insert_ids = ActiveRecord::Base.connection.exec_query("
              SELECT id_subrrogada_foranea FROM migra_modulos WHERE numero_fila = #{row.idx+1};
              ").rows.collect{|r| r[0]}

            insert_ids.each do |prestacion_id|
              if !(PrestacionAutorizada.where({:efector_id => convenio.efector.id, :prestacion_id => prestacion_id, :fecha_de_finalizacion => nil}).first)
                pa = PrestacionAutorizada.create!({
                  :efector_id => convenio.efector.id,
                  :prestacion_id => prestacion_id,
                  :fecha_de_inicio => convenio.fecha_de_inicio,
                  :autorizante_al_alta_id => convenio.id,
                  :autorizante_al_alta_type => 'ConvenioDeGestionSumar',
                  :creator_id => 1,
                  :updater_id => 1
                  })
              end
            end
          end
          
           if (row.idx+1) == 263
             break
           end
        end

        #Cargo la seccion 2 - 2.7
        sheet.each 267 do |row| 
          if row[13].to_s.match /s/i
            insert_ids = ActiveRecord::Base.connection.exec_query("
              SELECT id_subrrogada_foranea FROM migra_modulos WHERE numero_fila = #{row.idx+1};
              ").rows.collect{|r| r[0]}

            insert_ids.each do |prestacion_id|
              if !(PrestacionAutorizada.where({:efector_id => convenio.efector.id, :prestacion_id => prestacion_id, :fecha_de_finalizacion => nil}).first)
                pa = PrestacionAutorizada.create!({
                  :efector_id => convenio.efector.id,
                  :prestacion_id => prestacion_id,
                  :fecha_de_inicio => convenio.fecha_de_inicio,
                  :autorizante_al_alta_id => convenio.id,
                  :autorizante_al_alta_type => 'ConvenioDeGestionSumar',
                  :creator_id => 1,
                  :updater_id => 1
                  })
              end
            end
          end
          
           if (row.idx+1) == 276
             break
           end
        end
      end
    end
  end

end