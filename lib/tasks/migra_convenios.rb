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
              ( id ,   numero_fila ,  numero_columna_si_no ,  prestaciones ,  anexo ,     codigo, id_subrrogada_foranea )
              VALUES
              (#{ida}, #{row.idx+1},         13            , '#{row[0]}'     , '#{row[1]}', '#{row[10]}', #{row[14]});"
            ida+=1
            if (row.idx+1) == valores[:hasta]
              break
            end
          end
        end
      end

      ActiveRecord::Base.connection.execute "
      DELETE FROM migra_prestaciones WHERE id_subrrogada_foranea = -1;
      DELETE FROM migra_modulos WHERE id_subrrogada_foranea = -1;
      "
    end
  end

  def cargar_anexo

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
    ActiveRecord::Base.connection.execute "
      DELETE FROM migra_anexos;"

    ActiveRecord::Base.transaction do

      book = Spreadsheet.open @rutayarchivo
      sheet = book.worksheet @hoja
      id=0


      #Cargo los anexos
      ida =0
      limites_secciones.each do |seccion, valores|
        if valores[:tipo] == 'a'
          sheet.each valores[:desde] do |row|
            ActiveRecord::Base.connection.execute "
              INSERT INTO migra_anexos
              ( id ,   numero_fila ,  numero_columna_si_no ,  prestaciones ,  anexo ,     codigo, id_subrrogada_foranea )
              VALUES
              (#{ida}, #{row.idx+1},         13            , '#{row[0]}'     , '#{row[1]}', '#{row[10]}', #{row[14]});"
            ida+=1
            if (row.idx+1) == valores[:hasta]
              break
            end
          end
        end
      end

      ActiveRecord::Base.connection.execute "
      DELETE FROM migra_prestaciones WHERE id_subrrogada_foranea = -1;
      DELETE FROM migra_modulos WHERE id_subrrogada_foranea = -1;
      DELETE FROM migra_anexos WHERE id_subrrogada_foranea = -1;
      "
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

        puts '-----------------------------------------------------------------'
        puts 'se insertaron #{id-1} registros en la tabla de migra_prestaciones'
        puts '-----------------------------------------------------------------'

        ida=0

        limites_secciones.each do |seccion, valores|
          if valores[:tipo] == 'a'
            sheet.each valores[:desde] do |row|
              if row[valores[:col_si_no]].to_s.match /s/i
                insert_ids = ActiveRecord::Base.connection.exec_query("SELECT id_subrrogada_foranea FROM migra_anexos WHERE numero_fila = #{row.idx+1};").rows.collect{|r| r[0]}

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
