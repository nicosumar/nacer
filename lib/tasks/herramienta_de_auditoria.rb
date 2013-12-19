# -*- encoding : utf-8 -*-
class HerramientaDeAuditoria
  
  #uso:

  # HerramientaDeAuditoria.crear_tablespace("C:/Program Files/PostgreSQL/9.2/data")
  def self.crear_tablespace(arg_location)
    begin
      ActiveRecord::Base.connection.execute "create schema auditorias;\n"
      ActiveRecord::Base.connection.execute "CREATE TABLESPACE auditoria\n"+
                                            "OWNER nacer_adm\n"+
                                            "LOCATION '#{arg_location}';"
      puts "Tablespace creado correctamente"
    rescue Exception => e
      puts "Ocurrrio un error creando el tablespace. #{e.message}"
    end
  end

  def self.auditar_tabla(arg_nombre_de_tabla)
    tabla_original = arg_nombre_de_tabla
    tabla_auditoria = "auditoria_#{tabla_original}"

    begin
      ActiveRecord::Base.connection.execute ""+
        "CREATE TEMPORARY TABLE IF NOT EXISTS temp_op\n"+
        "(\n"+
        " op char(3),\n"+
        " fecha_op timestamp(6)\n"+
        ");\n"+
        "CREATE TABLE auditorias.#{tabla_auditoria}\n"+
        "    TABLESPACE auditoria\n"+
        "    AS select * from temp_op, #{tabla_original}\n"+
        "    WITH NO DATA ;\n"+
        "CREATE OR REPLACE FUNCTION public.auditar_#{tabla_original}() RETURNS TRIGGER AS $#{tabla_auditoria}$\n"+
        "    BEGIN\n"+
        "        IF (TG_OP = 'DELETE') THEN\n"+
        "            INSERT INTO auditorias.#{tabla_auditoria} SELECT 'DEL', now(), OLD.*;\n"+
        "            RETURN OLD;\n"+
        "        ELSIF (TG_OP = 'UPDATE') THEN\n"+
        "            INSERT INTO auditorias.#{tabla_auditoria} SELECT 'NEW', now(), NEW.*;\n"+
        "            INSERT INTO auditorias.#{tabla_auditoria} SELECT 'OLD', now(), OLD.*;\n"+
        "            RETURN NEW;\n"+
        "        ELSIF (TG_OP = 'INSERT') THEN\n"+
        "            INSERT INTO auditorias.#{tabla_auditoria} SELECT 'INS', now(), NEW.*;\n"+
        "            RETURN NEW;\n"+
        "        END IF;\n"+
        "        RETURN NULL; \n"+
        "    END;\n"+
        "$#{tabla_auditoria}$ LANGUAGE plpgsql;\n"+
        "CREATE TRIGGER trg_#{tabla_auditoria}\n"+
        "AFTER INSERT OR UPDATE OR DELETE ON #{tabla_original}\n"+
        "    FOR EACH ROW EXECUTE PROCEDURE public.auditar_#{tabla_original}();"

    rescue Exception => e
      puts "Ocurrrio un error creando la tabla. #{e.message}"
    end
  end

end
