# -*- encoding : utf-8 -*-
# Datos precargados al inicializar el sistema
Parametro.create([
  { #:id => 1,
    :nombre => "IdDeEstaProvincia",
    :tipo_postgres => "int4",
    :tipo_ruby => "Integer",
    :valor => "9" },
  { #:id => 2,
    :nombre => "EdadLimiteParaExigirAdultoResponsable",
    :tipo_postgres => "int4",
    :tipo_ruby => "Integer",
    :valor => "10" },
  { #:id => 3,
    :nombre => "EdadMinimaParaRegistrarEmbarazada",
    :tipo_postgres => "int4",
    :tipo_ruby => "Integer",
    :valor => "10" },
  { #:id => 4,
    :nombre => "VersionDelSistemaDeGestion",
    :tipo_postgres => "text",
    :tipo_ruby => "String",
    :valor => "4.7" }
])
