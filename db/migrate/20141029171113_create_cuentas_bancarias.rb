# -*- encoding : utf-8 -*-
class CreateCuentasBancarias < ActiveRecord::Migration
  def up
    create_table :cuentas_bancarias do |t|
      t.string :denominacion
      t.string :numero
      t.column :cbu, "varchar(27)"
      t.string :cuenta_contable
      t.references :tipo_de_cuenta_bancaria
      t.references :banco
      t.references :sucursal_bancaria
      t.references :entidad

      t.timestamps
    end

    add_index :cuentas_bancarias, :tipo_de_cuenta_bancaria_id
    add_index :cuentas_bancarias, :banco_id
    add_index :cuentas_bancarias, :sucursal_bancaria_id

    execute <<-SQL
      ALTER TABLE "public"."cuentas_bancarias"
        ADD FOREIGN KEY ("tipo_de_cuenta_bancaria_id") REFERENCES "public"."tipos_de_cuenta_bancaria" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
        ADD FOREIGN KEY ("banco_id") REFERENCES "public"."bancos" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
        ADD FOREIGN KEY ("sucursal_bancaria_id") REFERENCES "public"."sucursales_bancarias" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
        ADD UNIQUE ("numero", "banco_id", "sucursal_bancaria_id");
    SQL

    execute <<-SQL
      INSERT INTO public.cuentas_bancarias
      (denominacion, numero, tipo_de_cuenta_bancaria_id, banco_id, sucursal_bancaria_id, entidad_id, created_at, updated_at )
      SELECT initcap(regexp_replace(cuenta_denominacion, '["”“]','','g')  ) cuenta_denominacion,
            suc.cuenta_numero cuenta_numero,
            2 tipo_de_cuenta_bancaria_id, 
            1 banco_id,
            s.id sucursal_id, 
            ent.id entidad_id,
            now(), now()
      FROM 
        (
          SELECT DISTINCT e.id, e.nombre, regexp_replace(sucursal_cuenta_principal, '[^0-9]', '', 'g') sucursal_numero, numero_de_cuenta_principal cuenta_numero, e.denominacion_cuenta_principal cuenta_denominacion
          FROM efectores e
          WHERE id != 401
          AND sucursal_cuenta_principal IS NOT NULL
          AND ( EXISTS (
                        SELECT *
                        FROM convenios_de_administracion_sumar
                        WHERE convenios_de_administracion_sumar.administrador_id = e.id
                       ) 
                    OR  (
                          NOT EXISTS (
                                      SELECT *
                                        FROM convenios_de_administracion_sumar
                                        WHERE convenios_de_administracion_sumar.efector_id = e.id
                                      ) 
                          AND  EXISTS (
                                      SELECT *
                                      FROM convenios_de_gestion_sumar
                                      WHERE convenios_de_gestion_sumar.efector_id = e.id
                                      )
                        )
              )
          UNION 
          SELECT DISTINCT e.id, e.nombre, regexp_replace(sucursal_cuenta_secundaria, '[^0-9]', '', 'g'), numero_de_cuenta_secundaria, e.denominacion_cuenta_secundaria
          FROM efectores e
          WHERE id != 401
          AND sucursal_cuenta_secundaria IS NOT NULL
          AND ( EXISTS (
                        SELECT *
                        FROM convenios_de_administracion_sumar
                        WHERE convenios_de_administracion_sumar.administrador_id = e.id
                       ) 
                    OR  (
                          NOT EXISTS (
                                      SELECT *
                                        FROM convenios_de_administracion_sumar
                                        WHERE convenios_de_administracion_sumar.efector_id = e.id
                                      ) 
                          AND  EXISTS (
                                      SELECT *
                                      FROM convenios_de_gestion_sumar
                                      WHERE convenios_de_gestion_sumar.efector_id = e.id
                                      )
                        )
              )
        ) suc
          JOIN entidades ent on ent.entidad_id= suc."id" and ent.entidad_type = 'Efector'
          JOIN sucursales_bancarias s on s.numero = suc.sucursal_numero and s.banco_id = 1;
      --Cuenta Capitas Programa Sumar
      INSERT INTO public.cuentas_bancarias
        (denominacion, numero, tipo_de_cuenta_bancaria_id, banco_id, sucursal_bancaria_id, entidad_id, cbu, created_at, updated_at )
       SELECT 
        'Plan Nacer MZA FN' denominacion,
        '35600812/63' cuenta_numero,
        2 tipo_de_cuenta_bancaria_id, 
        1 banco_id,
        (select id from sucursales_bancarias s where s.numero = '2400' and s.banco_id = 1 limit 1) sucursal_id, 
        (select id from entidades where entidad_type = 'OrganismoGubernamental' and entidad_id = 1 limit 1)entidad_id,
        '0110 3562 2003 5600 8126 30' cbu,
        now(), now();
      --Cuenta Cofinanciamiento Programa Sumar
      INSERT INTO public.cuentas_bancarias
        (denominacion, numero, tipo_de_cuenta_bancaria_id, banco_id, sucursal_bancaria_id, entidad_id, cbu, created_at, updated_at )
       SELECT 
        'BN Contraparte Provincial Plan Nacer',
        '62801961/13' cuenta_numero,
        2 tipo_de_cuenta_bancaria_id, 
        1 banco_id,
        (select id from sucursales_bancarias s where s.numero = '2405' and s.banco_id = 1 limit 1) sucursal_id, 
        (select id from entidades where entidad_type = 'OrganismoGubernamental' and entidad_id = 1 limit 1)entidad_id,
        '0110 6288 2006 2801 9611 31' cbu,
        now(), now();
    SQL


  end

  def down
    drop_table :cuentas_bancarias
  end
end
