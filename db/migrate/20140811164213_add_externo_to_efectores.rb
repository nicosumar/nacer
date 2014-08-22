# -*- encoding : utf-8 -*-
class AddExternoToEfectores < ActiveRecord::Migration
  def up
    execute <<-SQL
      ALTER TABLE "public"."efectores"
        ADD COLUMN "provincia_id" int4,
        ADD FOREIGN KEY ("provincia_id") REFERENCES "public"."provincias" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
      CREATE INDEX  ON "public"."efectores" ("provincia_id"  );
      CREATE INDEX  ON "public"."efectores" ("cuie"  );

      UPDATE efectores
      SET provincia_id = 9;

      ALTER TABLE "public"."efectores"
        ALTER COLUMN "provincia_id" SET DEFAULT 9, ALTER COLUMN "provincia_id" SET NOT NULL;
    SQL
    e = Efector.create!([{
      cuie: "C09305",
      nombre: "Hospital GUTIÉRREZ",
      domicilio: "Sanchez de Bustamante 1330",
      provincia: Provincia.find(1), #caba
      telefonos: "4962-9247 / 9248 / 9280 Guardia: 4962-9232",
      integrante: false
      },
      {
      cuie: "C09307",
      nombre: "Hospital PEDRO de ELIZALDE",
      domicilio: "Manuel A. Montes de Oca 40",
      provincia: Provincia.find(1), #caba
      telefonos: "4307-5842/ 5844 Guardia: 4307-5442 / 4300-1700",
      integrante: false
      },
      {
      cuie: "C86001",
      nombre: "Hospital Juan P. Garrahan",
      domicilio: "Combate de los Pozos 1881",
      provincia: Provincia.find(1), #caba
      telefonos: "4941-8702",
      integrante: false
      },
      {
      cuie: "B12279",
      nombre: "Hospital de trauma y emergencias Dr. Federico Abete",
      domicilio: "MIRAFLORES N 125",
      provincia: Provincia.find(2), #Buenos Aires
      telefonos: "",
      integrante: false
      },
      {
      cuie: "B08440",
      nombre: "Hospital Nacional Profesor Alejandro Posadas",
      domicilio: "Pte. Illia s/n y Marconi - El Palomar (1684)",
      provincia: Provincia.find(2), #Buenos Aires
      telefonos: "(011) 4469-9300 - FAX: (011) 4654-7982",
      integrante: false
      },
      {
      cuie: "B08573",
      nombre: "Hospital materno infantil Dr. Tetamanti",
      domicilio: "CASTELLI 2450",
      provincia: Provincia.find(2), #Buenos Aires
      telefonos: "",
      integrante: false
      },
      {
      cuie: "B12182",
      nombre: "Hospital interzonal especializado de agudos Superiora Sor Maria Ludovica",
      domicilio: "14 n° 1651",
      provincia: Provincia.find(2), #Buenos Aires
      telefonos: "0221-4535901 al 10/912 /3",
      integrante: false
      },
      {
      cuie: "B12286",
      nombre: "Hospital el cruce",
      domicilio: "Av. Calchaquí N° 5401 e/Lope de Vega y Rastrador Fournier",
      provincia: Provincia.find(6), # Buenos Aires
      telefonos: "011-42107095/7096/7089",
      integrante: false 
      },
      {
      cuie: "X01429",
      nombre: "Hospital de niños de la Santisima Trinidad",
      domicilio: "BAJADA PUCARA 1900",
      provincia: Provincia.find(4), # Córdoba
      telefonos: "(0351)458-6438",
      integrante: false
      },
      {
      cuie: "W20108",
      nombre: "Instituto de Cardiologia Juana F. Cabral",
      domicilio: "Bolivar 1334",
      provincia: Provincia.find(5), # Corrientes
      telefonos: "(0351)458-6438",
      integrante: false
      },
      {
      cuie: "E06492",
      nombre: "Hospital San Roque",
      domicilio: "LA PAZ 435",
      provincia: Provincia.find(6), # Entre Ríos
      telefonos: "0343 - 4230460/4234377/4217366",
      integrante: false
      },
      {
      cuie: "A03593",
      nombre: "Hospital de niños Vilela",
      domicilio: "Virasoro 1855",
      provincia: Provincia.find(13), # Santa  Fe
      telefonos: "",
      integrante: false
      },
      {
      cuie: "S01296",
      nombre: "Hospital de niños Dr. Orlando Alassia",
      domicilio: "Mendoza 4151",
      provincia: Provincia.find(13), # Santa  Fe
      telefonos: "4505900/63/12/49",
      integrante: false
      },
      {
      cuie: "T01316",
      nombre: "Hospital del Niño Jesus",
      domicilio: "Pje. Hungria 700",
      provincia: Provincia.find(15), # Tucuman
      telefonos: "420 5341",
      integrante: false
      },
      {
      cuie: "Q06391",
      nombre: "Hospital provincial de Neuquén - Dr. Eduardo Castro Rendon",
      domicilio: "Buenos Aires 421- Ciudad Nqn",
      provincia: Provincia.find(21), # Neuquen
      telefonos: "0299-4490800",
      integrante: false
      }])
  end

  def down
    execute <<-SQL
      ALTER TABLE "public"."efectores"
        DROP COLUMN "provincia_id";
    SQL

  cuies = ["C09305", "C09307", "C86001", "B12279", "B08440", "B08573", "B12182", 
           "B12286", "X01429", "W20108", "E06492", "A03593", "S98621", "S01296", 
           "T01316", "Q06391"]
  Efector.where(cuie: cuies).each do |e|
    e.destroy
  end

  end
end
