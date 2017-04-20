class AddTriggerUpdateDatosSirge < ActiveRecord::Migration
  def up
    execute <<-SQL
    CREATE OR REPLACE FUNCTION update_datos_requeridos_sirge()
  RETURNS trigger AS
$BODY$
   

	DECLARE
      --Variables
      dato_reportable_sirge record ;
      dato_reportable record;
      dato_reportable_requerido record;
      cantidad_de_detalles_posteriores integer;
      ordenes integer[];
      siguiente_orden integer ;


    BEGIN


      
 --SELECT * INTO dato_reportable_birads2 FROM datos_reportables WHERE codigo = 'BIR
      
      --Obtengo las variables necesarias
       SELECT *  into dato_reportable  from datos_reportables where id =  NEW.dato_reportable_id limit 1;
       SELECT *  into  dato_reportable_sirge  from datos_reportables_sirge  where id = dato_reportable.dato_reportable_sirge_id  limit 1;
       ordenes =  array (select distinct orden from datos_reportables_requeridos_sirge where prestacion_id = NEW.prestacion_id order by orden);


       select 
       count (id) into  cantidad_de_detalles_posteriores from datos_reportables_requeridos 
       where 
       prestacion_id = NEW.prestacion_id 
       and dato_reportable_id =  NEW.dato_reportable_id 
       and id != NEW.id
       and (fecha_de_finalizacion is null or fecha_de_finalizacion > date('now') );


	if ( cantidad_de_detalles_posteriores <= 0 ) then


        if ( NEW.fecha_de_finalizacion is null or NEW.fecha_de_finalizacion > date('now')  ) then 

	

      --Determino el siguiente orden tentativo.
       if (   (array_length(ordenes, 1) = 0) is null    ) then

 	siguiente_orden  = 1;
 	--    RAISE EXCEPTION 'ordenes is null';
	elsif (1  !=  ANY (ordenes) ) then	
    --    RAISE EXCEPTION 'no hay 1';
        siguiente_orden  = 1;

	elsif (2 !=  ANY (ordenes) )  then	
--	    RAISE EXCEPTION 'no hay 2';
 	siguiente_orden  = 2;

        elsif (3 !=  ANY (ordenes) ) then	
    --        RAISE EXCEPTION 'no hay 3';
        siguiente_orden  = 3;

        elsif (4 !=  ANY (ordenes) ) then	
     --       RAISE EXCEPTION 'no hay 4';
        siguiente_orden  = 4;

      end if;

     




      

      --Solo se realizan actualizaciones si and solo si el dato reportable sirge existe.
      IF (dato_reportable_sirge is not null) then 
     
           
       if (NEW.es_requerido_sirge = 't') then
                
          if ( (		select id 
			  	        from 
			    		datos_reportables_requeridos_sirge 
			  		where 
			   		prestacion_id = NEW.prestacion_id 
			    		and dato_reportable_sirge_id = dato_reportable_sirge.id 
			    		) is null) then 

					
--RAISE EXCEPTION 'Entra al orden';
						if ( siguiente_orden is not null) then

						
								     INSERT INTO datos_reportables_requeridos_sirge(
										prestacion_id, dato_reportable_sirge_id, orden, created_at, 
										updated_at)
									 VALUES ( NEW.prestacion_id ,dato_reportable_sirge.id , siguiente_orden, date('now'), date('now'));
									
						end if;

			      	end if;



			elsif (NEW.es_requerido_sirge = 'f') then
			--RAISE EXCEPTION 'Entra al delete';
			--Si ya existe y selecciono que no quiero tenerlo
			
			delete from   datos_reportables_requeridos_sirge where 
					 prestacion_id = NEW.prestacion_id 
				and      dato_reportable_sirge_id = dato_reportable_sirge.id ;
	 		

	        end if;
	 
        end if;
	  	

        elsif (NEW.fecha_de_finalizacion is not null and NEW.fecha_de_finalizacion <= date('now')) then

			delete from   datos_reportables_requeridos_sirge where 
								 prestacion_id = NEW.prestacion_id 
							and      dato_reportable_sirge_id = dato_reportable_sirge.id ;
						
        

        end if;

        

     --Si tengo posteriores no hago nada
     end if;
     

     RETURN NULL; -- result is ignored since this is an AFTER trigger
      
    END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION update_datos_requeridos_sirge()
  OWNER TO postgres;
    

CREATE TRIGGER update_datos_reportables_requeridos_sirge
  AFTER INSERT OR UPDATE OF id, prestacion_id, dato_reportable_id, fecha_de_inicio, fecha_de_finalizacion, necesario, obligatorio, minimo, maximo, es_requerido_sirge
  ON datos_reportables_requeridos
  FOR EACH ROW
  EXECUTE PROCEDURE update_datos_requeridos_sirge();

update datos_reportables set dato_reportable_sirge_id = 1 where id = 1;
update datos_reportables set dato_reportable_sirge_id = 2 where id = 2;
update datos_reportables set dato_reportable_sirge_id = 5 where id = 3;
update datos_reportables set dato_reportable_sirge_id = 3 where id = 4;
update datos_reportables set dato_reportable_sirge_id = 3 where id = 5;
update datos_reportables set dato_reportable_sirge_id = 6 where id = 6;
update datos_reportables set dato_reportable_sirge_id = 6 where id = 7;
update datos_reportables set dato_reportable_sirge_id = 6 where id = 8;
update datos_reportables set dato_reportable_sirge_id = 8 where id = 16;
update datos_reportables set dato_reportable_sirge_id = 9 where id = 17;
update datos_reportables set dato_reportable_sirge_id = 10 where id = 18;
update datos_reportables set dato_reportable_sirge_id = 2 where id = 26;
update datos_reportables set dato_reportable_sirge_id = 4 where id = 27;
update datos_reportables set dato_reportable_sirge_id = 7 where id = 29;
update datos_reportables set dato_reportable_sirge_id = 7 where id = 30;
update datos_reportables set dato_reportable_sirge_id = 7 where id = 31;
update datos_reportables set dato_reportable_sirge_id = 14 where id = 35;
update datos_reportables set dato_reportable_sirge_id = 11 where id = 37;
update datos_reportables set dato_reportable_sirge_id = 1 where id = 38;
update datos_reportables set dato_reportable_sirge_id = 2 where id = 39;
update datos_reportables set dato_reportable_sirge_id = 5 where id = 40;
update datos_reportables set dato_reportable_sirge_id = 8 where id = 41;
update datos_reportables set dato_reportable_sirge_id = 9 where id = 42;
update datos_reportables set dato_reportable_sirge_id = 4 where id = 43;
update datos_reportables set dato_reportable_sirge_id = 12 where id = 44;
update datos_reportables set dato_reportable_sirge_id = 11 where id = 45;
update datos_reportables set dato_reportable_sirge_id = 14 where id = 47;
update datos_reportables set dato_reportable_sirge_id = 13 where id = 48;
update datos_reportables set dato_reportable_sirge_id = 16 where id = 49;
update datos_reportables set dato_reportable_sirge_id = 15 where id = 46;
update datos_reportables set dato_reportable_sirge_id = 17 where id = 9;
update datos_reportables set dato_reportable_sirge_id = 18 where id = 10;
update datos_reportables set dato_reportable_sirge_id = 19 where id = 11;
update datos_reportables set dato_reportable_sirge_id = 20 where id = 12;
update datos_reportables set dato_reportable_sirge_id = 21 where id = 13;
update datos_reportables set dato_reportable_sirge_id = 22 where id = 32;
update datos_reportables set dato_reportable_sirge_id = 23 where id = 33;
update datos_reportables set dato_reportable_sirge_id = 24 where id = 34;

    SQL
    
    
    
    
    
  end

  def down
  end
end
