# -*- encoding : utf-8 -*-
# Crear las restricciones adicionales en la base de datos
class GruposPdssSeed < ActiveRecord::Migration
  # Claves foráneas para asegurar la integridad referencial en el motor de la base de datos
  execute "
    ALTER TABLE grupos_pdss
      ADD CONSTRAINT fk_grupos_pdss_secciones_pdss
      FOREIGN KEY (seccion_pdss_id) REFERENCES secciones_pdss (id);
  "
end

# Datos precargados al inicializar el sistema
GrupoPdss.create!([
  {
    # :id => 1
    :nombre => "Embarazo, parto y puerperio",
    :codigo => "1.1",
    :seccion_pdss_id => 1,
    :orden => 1
  },
  {
    # :id => 2
    :nombre => "Embarazo de alto riesgo - Ambulatorio",
    :codigo => "1.2",
    :seccion_pdss_id => 1,
    :orden => 2
  },
  {
    # :id => 3
    :nombre => "Embarazo de alto riesgo - Internación",
    :codigo => "1.3",
    :seccion_pdss_id => 1,
    :prestaciones_modularizadas => true,
    :orden => 3
  },
  {
    # :id => 4
    :nombre => "Embarazo de alto riesgo - Hospital de día",
    :codigo => "1.4",
    :seccion_pdss_id => 1,
    :prestaciones_modularizadas => true,
    :orden => 4
  },
  {
    # :id => 5
    :nombre => "Embarazo, parto y puerperio; Embarazo de alto riesgo: Ambulatorio - Internación - Hospital de día",
    :codigo => "1.5",
    :seccion_pdss_id => 1,
    :orden => 5
  },
  {
    # :id => 6
    :nombre => "Recién nacido (posparto inmediato)",
    :codigo => "2.1",
    :seccion_pdss_id => 2,
    :orden => 1
  },
  {
    # :id => 7
    :nombre => "Recién nacido (malformaciones quirúrgicas)",
    :codigo => "2.2",
    :seccion_pdss_id => 2,
    :prestaciones_modularizadas => true,
    :orden => 2
  },
  {
    # :id => 8
    :nombre => "Seguimiento ambulatorio de RN de alto riesgo",
    :codigo => "2.3",
    :seccion_pdss_id => 2,
    :prestaciones_modularizadas => true,
    :orden => 3
  },
  {
    # :id => 9
    :nombre => "Cardiopatías congénitas: Estudios complementarios",
    :codigo => "2.4",
    :seccion_pdss_id => 2,
    :orden => 4
  },
  {
    # :id => 10
    :nombre => "Cardiopatías congénitas: Módulos quirúrgicos",
    :codigo => "2.5",
    :seccion_pdss_id => 2,
    :prestaciones_modularizadas => true,
    :orden => 5
  },
  {
    # :id => 11
    :nombre => "Cardiopatías congénitas: Prácticas complementarias a módulos quirúrgicos",
    :codigo => "2.6",
    :seccion_pdss_id => 2,
    :prestaciones_modularizadas => true,
    :orden => 6
  },
  {
    # :id => 12
    :nombre => "Cuidado de la salud",
    :codigo => "2.7",
    :seccion_pdss_id => 2,
    :orden => 7
  },
  {
    # :id => 13
    :nombre => "Cuidado de la salud; Recién nacido: posparto inmediato, malformaciones quirúrgicas; Seguimiento ambulatorio del RN de alto riesgo; Cardiopatías congénitas",
    :codigo => "2.8",
    :seccion_pdss_id => 2,
    :orden => 8
  },
  {
    # :id => 14
    :nombre => "Cuidado de la salud",
    :codigo => "3.1",
    :seccion_pdss_id => 3,
    :orden => 1
  },
  {
    # :id => 15
    :nombre => "Cardiopatías congénitas: Estudios complementarios",
    :codigo => "3.2",
    :seccion_pdss_id => 3,
    :orden => 2
  },
  {
    # :id => 16
    :nombre => "Cardiopatías congénitas: Módulos quirúrgicos",
    :codigo => "3.3",
    :seccion_pdss_id => 3,
    :prestaciones_modularizadas => true,
    :orden => 3
  },
  {
    # :id => 17
    :nombre => "Cardiopatías congénitas: Prácticas complementarias a módulos quirúrgicos",
    :codigo => "3.4",
    :seccion_pdss_id => 3,
    :prestaciones_modularizadas => true,
    :orden => 4
  },
  {
    # :id => 18
    :nombre => "Cuidado de la salud",
    :codigo => "4.1",
    :seccion_pdss_id => 4,
    :orden => 1
  },
  {
    # :id => 19
    :nombre => "Cardiopatías congénitas: Estudios complementarios",
    :codigo => "4.2",
    :seccion_pdss_id => 4,
    :orden => 2
  },
  {
    # :id => 20
    :nombre => "Cardiopatías congénitas: Módulos quirúrgicos",
    :codigo => "4.3",
    :seccion_pdss_id => 4,
    :prestaciones_modularizadas => true,
    :orden => 3
  },
  {
    # :id => 21
    :nombre => "Cardiopatías congénitas: Prácticas complementarias a módulos quirúrgicos",
    :codigo => "4.4",
    :seccion_pdss_id => 4,
    :prestaciones_modularizadas => true,
    :orden => 4
  },
  {
    # :id => 22
    :nombre => "Cuidado de la salud",
    :codigo => "5.1",
    :seccion_pdss_id => 5,
    :orden => 1
  },
  {
    # :id => 23
    :nombre => "Niños y niñas de 0 a 5 años - Recién nacido: módulos de malformaciones quirúrgicas",
    :codigo => "6.1",
    :seccion_pdss_id => 6,
    :orden => 1
  },
  {
    # :id => 24
    :nombre => "Niños y niñas de 0 a 5 años - Recién nacido: módulos de prematurez",
    :codigo => "6.2",
    :seccion_pdss_id => 6,
    :orden => 2
  },
  {
    # :id => 25
    :nombre => "Niños y niñas de 0 a 5 años - Cardiopatías congénitas: módulos quirúrgicos",
    :codigo => "6.3",
    :seccion_pdss_id => 6,
    :orden => 3
  },
  {
    # :id => 26
    :nombre => "Niños y niñas de 0 a 5 años - Cardiopatías congénitas: Prácticas complementarias a módulos quirúrgicos",
    :codigo => "6.4",
    :seccion_pdss_id => 6,
    :orden => 4
  },
  {
    # :id => 27
    :nombre => "Niños y niñas de 6 a 9 años y adolescentes - Cardiopatías congénitas: módulos quirúrgicos",
    :codigo => "6.5",
    :seccion_pdss_id => 6,
    :orden => 5
  },
  {
    # :id => 28
    :nombre => "Niños y niñas de 6 a 9 años y adolescentes - Cardiopatías congénitas: Prácticas complementarias a módulos quirúrgicos",
    :codigo => "6.6",
    :seccion_pdss_id => 6,
    :orden => 6
  },
  {
    # :id => 29
    :nombre => "Prácticas, imagenología y análisis de laboratorio",
    :codigo => "7.1",
    :seccion_pdss_id => 7,
    :orden => 1
  }
])
