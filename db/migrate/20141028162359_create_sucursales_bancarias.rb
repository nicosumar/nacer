# -*- encoding : utf-8 -*-
class CreateSucursalesBancarias < ActiveRecord::Migration
  def up
    create_table :sucursales_bancarias do |t|
      t.string :nombre
      t.string :numero, null: false
      t.references :banco, null: false
      t.references :pais, null: false
      t.references :provincia, null: false
      t.references :departamento
      t.references :distrito
      t.text :observaciones

      t.timestamps
    end

    add_index :sucursales_bancarias, :pais_id
    add_index :sucursales_bancarias, :provincia_id
    add_index :sucursales_bancarias, :departamento_id
    add_index :sucursales_bancarias, :distrito_id
    add_index :sucursales_bancarias, :banco_id

    execute <<-SQL
      ALTER TABLE "public"."sucursales_bancarias"
        ADD FOREIGN KEY ("banco_id") REFERENCES "public"."bancos" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
        ADD FOREIGN KEY ("pais_id") REFERENCES "public"."paises" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
        ADD FOREIGN KEY ("provincia_id") REFERENCES "public"."provincias" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
        ADD FOREIGN KEY ("departamento_id") REFERENCES "public"."departamentos" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
        ADD FOREIGN KEY ("distrito_id") REFERENCES "public"."distritos" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
        ADD UNIQUE ("banco_id", "numero");
    SQL

    # Creo la del patagonia
    SucursalBancaria.create({
      banco: Banco.find(2),
      nombre: "Sucursal Barrio Cívico",
      numero: "300",
      pais: Pais.find(1),
      provincia: Provincia.find(9),
      departamento: Departamento.find(9),
      observaciones: "Sucursal creada por el proceso automatico de migración. Por favor, corrija cualquier dato incompleto o erroneo y borre este mensaje"
      }, :without_protection => true)

    # Creo las sucursales del banco nación
    execute <<-SQL
      INSERT INTO "public".sucursales_bancarias
                ( banco_id, 
                  numero, 
                  pais_id, 
                  provincia_id, 
                  observaciones,
                  created_at, updated_at)
      SELECT 1 banco_id,  
            sucursal_numero, 
            1 pais_id , 
            9 provincia_id, 
            'Sucursal creada por el proceso automatico de migración. Por favor, corrija cualquier dato incompleto o erroneo y borre este mensaje' observaciones,
            NOW(), NOW()
      FROM 
        (
          SELECT DISTINCT regexp_replace(sucursal_cuenta_principal, '[^0-9]', '', 'g') sucursal_numero
          FROM efectores
          WHERE id != 401
          AND sucursal_cuenta_principal IS NOT NULL
          UNION 
          SELECT DISTINCT  regexp_replace(sucursal_cuenta_secundaria, '[^0-9]', '', 'g')
          FROM efectores
          WHERE id != 401
          AND sucursal_cuenta_secundaria IS NOT NULL
        ) suc
    SQL
  end

  def down
    drop_table :sucursales_bancarias
  end
end
