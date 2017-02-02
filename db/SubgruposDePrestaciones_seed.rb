# -*- encoding : utf-8 -*-
# Crear las restricciones adicionales en la base de datos
class ModificarSubgrupoDePrestaciones < ActiveRecord::Migration
  execute "
    ALTER TABLE subgrupos_de_prestaciones
      ADD CONSTRAINT fk_subgrupos_grupos_prest
      FOREIGN KEY (grupo_de_prestaciones_id) REFERENCES grupos_de_prestaciones (id);
  "
end

# Datos precargados al inicializar el sistema
SubgrupoDePrestaciones.create([
        { #:id => 1,
          :grupo_de_prestaciones_id => 1,
          :nombre => "Embarazo" },
        { #:id => 2,
          :grupo_de_prestaciones_id => 1,
          :nombre => "Embarazo de alto riesgo" },
        { #:id => 3,
          :grupo_de_prestaciones_id => 1,
          :nombre => "Parto" },
        { #:id => 4,
          :grupo_de_prestaciones_id => 1,
          :nombre => "Puerperio" },
        { #:id => 5,
          :grupo_de_prestaciones_id => 2,
          :nombre => "Neonato" },
        { #:id => 6,
          :grupo_de_prestaciones_id => 2,
          :nombre => "Niños menores de 6 años (no incluye neonatos)" }
])
