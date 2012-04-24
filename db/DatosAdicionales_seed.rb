# Datos precargados al inicializar el sistema
DatoAdicional.create([
        { #:id => 1,
          :nombre => "Fecha de nacimiento",
          :tipo_postgres => "date",
          :tipo_ruby => "Date",
          :enumerable => false },
        { #:id => 2,
          :nombre => "Número de control",
          :tipo_postgres => "int4",
          :tipo_ruby => "Integer",
          :enumerable => false },
        { #:id => 3,
          :nombre => "Peso actual (en kg)",
          :tipo_postgres => "numeric",
          :tipo_ruby => "Float",
          :enumerable => false },
        { #:id => 4,
          :nombre => "Talla (en cm)",
          :tipo_postgres => "int4",
          :tipo_ruby => "Integer",
          :enumerable => false },
        { #:id => 5,
          :nombre => "Perímetro cefálico (en cm)",
          :tipo_postgres => "int4",
          :tipo_ruby => "Integer",
          :enumerable => false },
        { #:id => 6,
          :nombre => "Percentil Peso/Edad",
          :tipo_postgres => "int4",
          :tipo_ruby => "Integer",
          :enumerable => true,
          :clase_para_enumeracion => "PercentilPesoEdad" },
        { #:id => 7,
          :nombre => "Percentil Perímetro cefálico/Edad",
          :tipo_postgres => "int4",
          :tipo_ruby => "Integer",
          :enumerable => true,
          :clase_para_enumeracion => "PercentilPcEdad" },
        { #:id => 8,
          :nombre => "Percentil IMC/Edad",
          :tipo_postgres => "int4",
          :tipo_ruby => "Integer",
          :enumerable => true,
          :clase_para_enumeracion => "PercentilImcEdad" },
        { #:id => 9,
          :nombre => "Número de pedido del profesional",
          :tipo_postgres => "text",
          :tipo_ruby => "String",
          :enumerable => false },
        { #:id => 10,
          :nombre => "Número de informe",
          :tipo_postgres => "text",
          :tipo_ruby => "String",
          :enumerable => false },
        { #:id => 11,
          :nombre => "Fecha de la última menstruación",
          :tipo_postgres => "date",
          :tipo_ruby => "Date",
          :enumerable => false },
        { #:id => 12,
          :nombre => "Fecha probable de parto",
          :tipo_postgres => "date",
          :tipo_ruby => "Date",
          :enumerable => false },
        { #:id => 13,
          :nombre => "Fecha de parto",
          :tipo_postgres => "date",
          :tipo_ruby => "Date",
          :enumerable => false },
        { #:id => 14,
          :nombre => "Score de Apgar a los 5'",
          :tipo_postgres => "int4",
          :tipo_ruby => "Integer",
          :enumerable => false },
        { #:id => 15,
          :nombre => "Peso del recién nacido (kg)",
          :tipo_postgres => "numeric",
          :tipo_ruby => "Float",
          :enumerable => false },
        { #:id => 16,
          :nombre => "Posee VDRL/Antitetánica",
          :tipo_postgres => "int4",
          :tipo_ruby => "Integer",
          :enumerable => true,
          :clase_para_enumeracion => "SiNo" },
        { #:id => 17,
          :nombre => "Consejería de salud reproductiva",
          :tipo_postgres => "int4",
          :tipo_ruby => "Integer",
          :enumerable => true,
          :clase_para_enumeracion => "SiNo" },
        { #:id => 18,
          :nombre => "Percentil Peso/Talla",
          :tipo_postgres => "int4",
          :tipo_ruby => "Integer",
          :enumerable => true,
          :clase_para_enumeracion => "PercentilPesoTalla" },
        { #:id => 19,
          :nombre => "Índice de masa corporal",
          :tipo_postgres => "numeric",
          :tipo_ruby => "Float",
          :enumerable => false },
        { #:id => 20,
          :nombre => "Percentil Talla/Edad",
          :tipo_postgres => "int4",
          :tipo_ruby => "Integer",
          :enumerable => true,
          :clase_para_enumeracion => "PercentilTallaEdad" },
        { #:id => 21,
          :nombre => "Prueba de laboratorio",
          :tipo_postgres => "int4",
          :tipo_ruby => "Integer",
          :enumerable => true,
          :clase_para_enumeracion => "PruebaDeLaboratorio" }
])
