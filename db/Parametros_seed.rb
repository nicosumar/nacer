# Datos precargados al inicializar el sistema
Parametro.create([
  { #:id => 1,
    :nombre => "IdDeEstaProvincia",
    :tipo_postgres => "int4",
    :tipo_ruby => "Integer",
    :valor => "9" },
  { #:id => 2,
    :nombre => "CodigoDeUadDelSistema",
    :tipo_postgres => "text",
    :tipo_ruby => "String",
    :valor => "006" },
  { #:id => 3,
    :nombre => "EdadLimiteParaExigirAdultoResponsable",
    :tipo_postgres => "int4",
    :tipo_ruby => "Integer",
    :valor => "15" },
  { #:id => 4,
    :nombre => "EdadMinimaParaRegistrarEmbarazada",
    :tipo_postgres => "int4",
    :tipo_ruby => "Integer",
    :valor => "10" }
])
