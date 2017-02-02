# -*- encoding : utf-8 -*-
# Datos precargados al inicializar el sistema
GrupoDeEfectores.create([
        { #:id => 1,
          :nombre => "Hospitales públicos",
          :tipo_de_efector => "HOS",
          :centro_integrador_comunitario => false,
          :grupo_bio_id => 0 },
        { #:id => 2,
          :nombre => "Centros de salud",
          :tipo_de_efector => "CSA",
          :centro_integrador_comunitario => false,
          :grupo_bio_id => 1 },
        { #:id => 3,
          :nombre => "Postas sanitarias",
          :tipo_de_efector => "PSB",
          :centro_integrador_comunitario => false,
          :grupo_bio_id => 1 },
        { #:id => 4,
          :nombre => "Administradores",
          :tipo_de_efector => "ADM",
          :centro_integrador_comunitario => true,
          :grupo_bio_id => 2 },
        { #:id => 5,
          :nombre => "Centros de integración comunitaria",
          :tipo_de_efector => "CSA",
          :centro_integrador_comunitario => true,
          :grupo_bio_id => 10 }
])
