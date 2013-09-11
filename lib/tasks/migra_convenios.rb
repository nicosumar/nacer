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

  def initialize(template_ruta_y_archivo)
    @rutayarchivo = args
  end

  def cargar_datos
    ActiveRecord::Base.connection.schema_search_path = "public"
    limites_secciones = {:seccion11  => {desde: 43 ,hasta:  55 , col_si_no: 13, tipo: 'p', grupo: '1', col_id_subrogada: 14, subgrupo: '1.1'},
                         :seccion12a => {desde: 99 ,hasta:  162, col_si_no: 13, tipo: 'p', grupo: '1', col_id_subrogada: 14, subgrupo: '1.2-a'},
                         :seccion21  => {desde: 190,hasta:  200, col_si_no: 13, tipo: 'p', grupo: '2', col_id_subrogada: 14, subgrupo: '2.1'},
                         :seccion25  => {desde: 226,hasta:  232, col_si_no: 13, tipo: 'p', grupo: '2', col_id_subrogada: 14, subgrupo: '2.5'},
                         :seccion27  => {desde: 280,hasta:  326, col_si_no: 13, tipo: 'p', grupo: '2', col_id_subrogada: 14, subgrupo: '2.7'},
                         :seccion31  => {desde: 332,hasta:  367, col_si_no: 13, tipo: 'p', grupo: '3', col_id_subrogada: 14, subgrupo: '3.1'},
                         :seccion41  => {desde: 374,hasta:  428, col_si_no: 13, tipo: 'p', grupo: '4', col_id_subrogada: 14, subgrupo: '4.1'},
                         :seccion51  => {desde: 435,hasta:  482, col_si_no: 13, tipo: 'p', grupo: '5', col_id_subrogada: 14, subgrupo: '5.1'},
                         :seccion_modulo_12b   => {desde: 167,hasta:  173, col_si_no: 13, tipo: 'm', grupo: '1', col_id_subrogada: 14, subgrupo: '1.2.-B'},
                         :seccion_modulo_12c   => {desde: 177,hasta:  180, col_si_no: 11, tipo: 'm', grupo: '1', col_id_subrogada: 12, subgrupo: '1.2.-C'},
                         :seccion_modulo_12d   => {desde: 184,hasta:  185, col_si_no: 11, tipo: 'm', grupo: '1', col_id_subrogada: 11, subgrupo: '1.2.-D'},
                         :seccion_modulo_22    => {desde: 204,hasta:  207, col_si_no: 13, tipo: 'm', grupo: '2', col_id_subrogada: 14, subgrupo: '2.2'},
                         :seccion_modulo_23    => {desde: 211,hasta:  213, col_si_no: 11, tipo: 'm', grupo: '2', col_id_subrogada: 12, subgrupo: '2.3'},
                         :seccion_modulo_24    => {desde: 217,hasta:  218, col_si_no: 11, tipo: 'm', grupo: '2', col_id_subrogada: 12, subgrupo: '2.4'},
                         :seccion_modulo_26c1  => {desde: 236,hasta:  246, col_si_no: 13, tipo: 'm', grupo: '2', col_id_subrogada: 14, subgrupo: '2.6'},
                         :seccion_modulo_26c2  => {desde: 249,hasta:  253, col_si_no: 13, tipo: 'm', grupo: '2', col_id_subrogada: 14, subgrupo: '2.6'},
                         :seccion_modulo_26c3  => {desde: 255,hasta:  260, col_si_no: 13, tipo: 'm', grupo: '2', col_id_subrogada: 14, subgrupo: '2.6'},
                         :seccion_modulo_26c4  => {desde: 262,hasta:  263, col_si_no: 13, tipo: 'm', grupo: '2', col_id_subrogada: 14, subgrupo: '2.6'},
                         :seccion_modulo_7     => {desde: 267,hasta:  276, col_si_no: 13, tipo: 'm', grupo: '2', col_id_subrogada: 14, subgrupo: '2.7'},
                         :seccion_anexo_1  => {desde: 487,hasta:  569, col_si_no: 13, tipo: 'a'},
                         :seccion_anexo_1  => {desde: 572,hasta:  569, col_si_no: 13, tipo: 'a'},
                         :seccion_anexo_1  => {desde: 660,hasta:  687, col_si_no: 13, tipo: 'a'}
    }

    ActiveRecord::Base.transaction do

      book = Spreadsheet.open @rutayarchivo
      sheet = book.worksheet @hoja
      id=0

      limites_secciones.each do |seccion, valores|
        if valores[:tipo] == 'p'
        	sheet.each valores[:desde] do |row| 

            if row[valores[:col_id_subrogada]].to_s.match /p/
              row[14].split('p').each do | ids |
                ActiveRecord::Base.connection.execute "
                  INSERT INTO migra_prestaciones 
                  ( id ,  numero_fila ,  numero_columna_si_no ,  grupo              ,  subgrupo           ,  nosologia  ,  tipo_de_prestacion ,  nombre_prestacion ,  codigos                 ,  precio   ,  rural ,id_subrrogada_foranea)  
                  VALUES                                   
                  (#{id}, #{row.idx+1} , #{valores[:col_si_no]}, #{valores[:grupo]}, #{valores[:subgrupo]},    '#{row[0]}',            '#{row[1]}',           '#{row[2]}', '#{row[8] + ' ' + row[10]}', '#{row[11]}', '#{row[12]}', #{ids});"
                id+=1
                if (row.idx+1) == valores[:hasta] 
                  break
                end
              end
            else

              ActiveRecord::Base.connection.execute "
                INSERT INTO migra_prestaciones 
                ( id ,  numero_fila ,  numero_columna_si_no ,  grupo ,  subgrupo ,  nosologia  ,  tipo_de_prestacion ,  nombre_prestacion ,  codigos                 ,  precio   ,  rural ,id_subrrogada_foranea)  
                VALUES                                   
                (#{id}, #{row.idx+1} , #{valores[:col_si_no]}, #{valores[:grupo]}, #{valores[:subgrupo]},    '#{row[0]}',            '#{row[1]}',           '#{row[2]}', '#{row[8] + ' ' + row[10]}', '#{row[11]}', '#{row[12]}', #{row[valores[:col_id_subrogada]]});"
              id+=1
              if (row.idx+1) == 95
                break
              end
            end
          end
        end
      end
      
      puts '-----------------------------------------------------------------'
      puts 'se insertaron #{id-1} registros en la tabla de migra_prestaciones'
      puts '-----------------------------------------------------------------'

      idm=0
      limites_secciones.each do |seccion, valores|
        if valores[:tipo]=='m'
          sheet.each valores[:desde] do |row| 
            ActiveRecord::Base.connection.execute "
              INSERT INTO migra_modulos 
              ( id   ,  numero_fila ,  numero_columna_si_no ,  grupo             ,  subgrupo            ,   modulo ,  definicion_cirugia_conceptos ,  codigos   , id_subrrogada_foranea ) 
              VALUES 
              (#{idm},#{row.idx+1}  , #{valores[:col_si_no]},  #{valores[:grupo]}, #{valores[:subgrupo]}, '#{row[2]}',                         NULL, '#{row[7]}','#{row[valores[:col_id_subrogada]]}' );"
            idm+=1
            if (row.idx+1) == valores[:hasta]
              break
            end
          end
        end
      end
      puts '-----------------------------------------------------------------'
      puts 'se insertaron #{idM-1} registros en la tabla de migra_modulos'
      puts '-----------------------------------------------------------------'
 
  	  #Cargo los anexos
      ida =0
      limites_secciones.each do |seccion, valores|
        if valores[:tipo] == 'a'
          sheet.each valores[:desde] do |row| 
            ActiveRecord::Base.connection.execute "
              INSERT INTO migra_anexos 
              ( id ,   numero_fila ,  numero_columna_si_no ,  prestaciones ,  anexo ,     codigo ) 
              VALUES 
              (#{ida}, #{row.idx+1},         13            , '#{row[0]}'     , '#{row[1]}', '#{row[10]}');"
            ida+=1
            if (row.idx+1) == valores[:hasta]
              break
            end
          end
        end
      end

      ActiveRecord::Base.connection.execute "
      DELETE FROM migra_prestaciones WHERE id_subrrogada_foranea = -1;
      DELETE FROM migra_modulos WHERE id_subrrogada_foranea = -1;"
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
        WITH (OIDS=FALSE);

  		CREATE INDEX "migra_prestaciones_numero_fila_idx" ON "public"."migra_prestaciones" USING btree (numero_fila);
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
        )  WITH (OIDS=FALSE);
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
        )   WITH (OIDS=FALSE);
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



  def self.crear_convenios_prestaciones
        limites_secciones = {:seccion11  => {desde: 43 ,hasta:  55 , col_si_no: 13, tipo: 'p', grupo: '1', col_id_subrogada: 14, subgrupo: '1.1'},
                         :seccion12a => {desde: 99 ,hasta:  162, col_si_no: 13, tipo: 'p', grupo: '1', col_id_subrogada: 14, subgrupo: '1.2-a'},
                         :seccion21  => {desde: 190,hasta:  200, col_si_no: 13, tipo: 'p', grupo: '2', col_id_subrogada: 14, subgrupo: '2.1'},
                         :seccion25  => {desde: 226,hasta:  232, col_si_no: 13, tipo: 'p', grupo: '2', col_id_subrogada: 14, subgrupo: '2.5'},
                         :seccion27  => {desde: 280,hasta:  326, col_si_no: 13, tipo: 'p', grupo: '2', col_id_subrogada: 14, subgrupo: '2.7'},
                         :seccion31  => {desde: 332,hasta:  367, col_si_no: 13, tipo: 'p', grupo: '3', col_id_subrogada: 14, subgrupo: '3.1'},
                         :seccion41  => {desde: 374,hasta:  428, col_si_no: 13, tipo: 'p', grupo: '4', col_id_subrogada: 14, subgrupo: '4.1'},
                         :seccion51  => {desde: 435,hasta:  482, col_si_no: 13, tipo: 'p', grupo: '5', col_id_subrogada: 14, subgrupo: '5.1'},
                         :seccion_modulo_12b   => {desde: 167,hasta:  173, col_si_no: 13, tipo: 'm', grupo: '1', col_id_subrogada: 14, subgrupo: '1.2.-B'},
                         :seccion_modulo_12c   => {desde: 177,hasta:  180, col_si_no: 11, tipo: 'm', grupo: '1', col_id_subrogada: 12, subgrupo: '1.2.-C'},
                         :seccion_modulo_12d   => {desde: 184,hasta:  185, col_si_no: 11, tipo: 'm', grupo: '1', col_id_subrogada: 11, subgrupo: '1.2.-D'},
                         :seccion_modulo_22    => {desde: 204,hasta:  207, col_si_no: 13, tipo: 'm', grupo: '2', col_id_subrogada: 14, subgrupo: '2.2'},
                         :seccion_modulo_23    => {desde: 211,hasta:  213, col_si_no: 11, tipo: 'm', grupo: '2', col_id_subrogada: 12, subgrupo: '2.3'},
                         :seccion_modulo_24    => {desde: 217,hasta:  218, col_si_no: 11, tipo: 'm', grupo: '2', col_id_subrogada: 12, subgrupo: '2.4'},
                         :seccion_modulo_26c1  => {desde: 236,hasta:  246, col_si_no: 13, tipo: 'm', grupo: '2', col_id_subrogada: 14, subgrupo: '2.6'},
                         :seccion_modulo_26c2  => {desde: 249,hasta:  253, col_si_no: 13, tipo: 'm', grupo: '2', col_id_subrogada: 14, subgrupo: '2.6'},
                         :seccion_modulo_26c3  => {desde: 255,hasta:  260, col_si_no: 13, tipo: 'm', grupo: '2', col_id_subrogada: 14, subgrupo: '2.6'},
                         :seccion_modulo_26c4  => {desde: 262,hasta:  263, col_si_no: 13, tipo: 'm', grupo: '2', col_id_subrogada: 14, subgrupo: '2.6'},
                         :seccion_modulo_7     => {desde: 267,hasta:  276, col_si_no: 13, tipo: 'm', grupo: '2', col_id_subrogada: 14, subgrupo: '2.7'},
                         :seccion_anexo_1  => {desde: 487,hasta:  569, col_si_no: 13, tipo: 'a'},
                         :seccion_anexo_1  => {desde: 572,hasta:  569, col_si_no: 13, tipo: 'a'},
                         :seccion_anexo_1  => {desde: 660,hasta:  687, col_si_no: 13, tipo: 'a'}
    }
    ruta = 'lib/tasks/archproc/'
    # archivos = ['HOSPITAL CARRILLO final-des.xls',
    #   'PlandeServdeSalud_Env a UEC_UltVer_May13 LAGO FINAL-des.xls',
    #   'PlandeServdeSalud_Env a UEC_UltVer_May13 NOTTI FINAL-des.xls',
    #   'PlandeServdeSalud_Env a UEC_UltVer_May13 PAROISSIEN-des.xls',
    #   'PlandeServdeSalud_Env a UEC_UltVer_May13 PERRUPATO-des.xls',
    #   'PlandeServdeSalud_Env a UEC_UltVer_May13 Schestakow-des.xls',
    #   'PlandeServdeSalud Gailhac FINAL-des.xls',
    #   'PlandeServdeSalud hospital LAS HERAS FINAL-des.xls',
    #   'PlandeServdeSalud_May13 FINAL-des.xls',
    #   'PlandeServdeSalud_May13 ok Hptal EVA PERON-des.xls',
    #   'Plan deServdeSalud sumar.ILLIA Final-des.xls',
    #   'Plan de Servicio_El Sauce ro-des.xls',
    #   'Plan de Servicios de Salud Mayo 2013saporit-des.xls',
    #   'PLAN DE SERVICIOS DE SALUD SICOLI FINAL-des.xls',
    #   'PLAN SUMAR HOSPITAL MALARGUE final-des.xls',
    #   'SERVICIO SALUD SUMAR final-des.xls',
    #   'SUMAR Raffo Final-des.xls']

   archivos = ['PlandeServdeSalud 2013 - CS 136-des.xls',
      'PlandeServdeSalud 2013 - CS 139-des.xls',
      'PlandeServdeSalud 2013 - CS17-des.xls',
      'PlandeServdeSalud 2013 - CS18-des.xls',
      'PlandeServdeSalud 2013 - CS20-des.xls',
      'PlandeServdeSalud 2013 - CS21-des.xls',
      'PlandeServdeSalud 2013 - CS221-des.xls',
      'PlandeServdeSalud 2013 - CS 226-des.xls',
      'PlandeServdeSalud 2013 - CS 22-des.xls',
      'PlandeServdeSalud 2013 - CS 234-des.xls',
      'PlandeServdeSalud 2013 - CS 25-des.xls',
      'PlandeServdeSalud 2013 - P 530-des.xls',
      'PlandeServdeSalud 2013 - P 549-des.xls',
      'PlandeServdeSalud Area Sanitaria Capital-des.xls',
      'PlandeServdeSalud_cs 1 v.1-des.xls',
      'PlandeServdeSalud_cs 2 v.1-des.xls',
      'PlandeServdeSalud CS 62 JUNIN-des.xls']

    ActiveRecord::Base.connection.schema_search_path = "public"
    archivos.each do |ra|
      @rutayarchivo = ruta + ra
      ActiveRecord::Base.transaction do

        book = Spreadsheet.open @rutayarchivo
        sheet = book.worksheet 0
        id=0
        convenio = ConvenioDeGestionSumar.find_by_numero!(sheet.row(34)[5])

        limites_secciones.each do |seccion, valores|
          if valores[:tipo] == 'p'
            sheet.each valores[:desde] do |row|
              if row[valores[:col_si_no]].to_s.match /s/i
                insert_ids = ActiveRecord::Base.connection.exec_query("SELECT id_subrrogada_foranea FROM migra_prestaciones WHERE numero_fila = #{row.idx+1};").rows.collect{|r| r[0]}

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
              break if (row.idx+1) == valores[:hasta]
            end
          end
        end

        puts '-----------------------------------------------------------------'
        puts 'se insertaron #{id-1} registros en la tabla de migra_prestaciones'
        puts '-----------------------------------------------------------------'

        idm=0

        limites_secciones.each do |seccion, valores|
          if valores[:tipo] == 'm'
            sheet.each valores[:desde] do |row| 
              if row[valores[:col_si_no]].to_s.match /s/i
                insert_ids = ActiveRecord::Base.connection.exec_query("SELECT id_subrrogada_foranea FROM migra_modulos WHERE numero_fila = #{row.idx+1};").rows.collect{|r| r[0]}

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
              break if (row.idx+1) == valores[:hasta]
            end
          end
        end
  
      end
    end
  
  end


end