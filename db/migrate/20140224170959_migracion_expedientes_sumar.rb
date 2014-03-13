class MigracionExpedientesSumar < ActiveRecord::Migration
  def up
    execute <<-SQL
      ALTER TABLE "public"."expedientes_sumar" DISABLE TRIGGER "generar_numero_de_expediente";
      ALTER TABLE "public"."liquidaciones_informes"
        ADD COLUMN "expediente_sumar_id" int4;
      CREATE INDEX  ON "public"."liquidaciones_informes" USING btree ("expediente_sumar_id"  );
      
      INSERT INTO expedientes_sumar
      ( numero, tipo_de_expediente_id, created_at, updated_at)
      select  DISTINCT li.numero_de_expediente, 1 tipo_de_expediente, now(), now()
      from liquidaciones_informes li 
      where li.numero_de_expediente is not null;

      update liquidaciones_informes 
      set expediente_sumar_id = e.id 
      from expedientes_sumar e 
        join liquidaciones_informes l on l.numero_de_expediente = e.numero
      where l.id = liquidaciones_informes.id ;

      ALTER TABLE "public"."expedientes_sumar" ENABLE TRIGGER "generar_numero_de_expediente";
    SQL

    # Actualizo los expedientes que si existen en las liquidaciones
    li = LiquidacionInforme.where("expediente_sumar_id is not NULL").includes(:liquidacion_sumar, :efector)
    tipo = TipoDeExpediente.find(1)
    li.each do |l|
      e = ExpedienteSumar.find(l.expediente_sumar.id)
      e.update_attributes({ tipo_de_expediente: tipo,
                            liquidacion_sumar: l.liquidacion_sumar,
                            efector: l.efector.administrador_sumar.present? ? l.efector.administrador_sumar : l.efector,
                            periodo: l.liquidacion_sumar.periodo,
                            liquidacion_sumar_cuasifactura: l.efector.administrador_sumar.present? ? l.efector.administrador_sumar.cuasifactura_de_periodo(l.liquidacion_sumar.periodo)
                                                                                             : l.efector.cuasifactura_de_periodo(l.liquidacion_sumar.periodo),
                            consolidado_sumar: l.efector.administrador_sumar.present? ? l.efector.administrador_sumar.consolidado_de_periodo(l.liquidacion_sumar.periodo) : nil
        })
      e.save
    end

    # Los informes que no tienen expedientes, se les generan
    li = LiquidacionInforme.where("numero_de_expediente is NULL").includes(:liquidacion_sumar, :efector)
    tipo = TipoDeExpediente.find(1)
    li.each do |l|
      ex = ExpedienteSumar.where( liquidacion_sumar_id: l.liquidacion_sumar.id, 
                                  tipo_de_expediente_id: 1,
                                  efector_id: l.efector.administrador_sumar.present? ? l.efector.administrador_sumar.id : l.efector.id)
      if ex.size == 0
        e = ExpedienteSumar.create({  tipo_de_expediente: tipo,
                                      liquidacion_sumar: l.liquidacion_sumar,
                                      efector: l.efector.administrador_sumar.present? ? l.efector.administrador_sumar : l.efector,
                                      periodo: l.liquidacion_sumar.periodo,
                                      liquidacion_sumar_cuasifactura: l.efector.administrador_sumar.present? ? l.efector.administrador_sumar.cuasifactura_de_periodo(l.liquidacion_sumar.periodo)
                                                                                                       : l.efector.cuasifactura_de_periodo(l.liquidacion_sumar.periodo),
                                      consolidado_sumar: l.efector.administrador_sumar.present? ? l.efector.administrador_sumar.consolidado_de_periodo(l.liquidacion_sumar.periodo) : nil
          })
        e.save
        l.expediente_sumar = e
        l.save
      elsif ex.size > 0
        l.expediente_sumar = ex.first
        l.save
      end
    end

    execute <<-SQL
      ALTER TABLE "public"."liquidaciones_informes"
        DROP COLUMN "numero_de_expediente";
    SQL
  end

  def down
  end

end
