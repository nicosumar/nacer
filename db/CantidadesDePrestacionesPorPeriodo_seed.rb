# -*- encoding : utf-8 -*-
# Datos precargados al inicializar el sistema

# Crear nuevas restricciones de claves foráneas
ActiveRecord::Base.connection.execute "
  ALTER TABLE cantidades_de_prestaciones_por_periodo
    ADD CONSTRAINT fk_cc_pp_pp_pp_prestaciones
      FOREIGN KEY (prestacion_id) REFERENCES prestaciones(id);
"

# Añado un método de validación para validar que no se exceda una cierta cantidad de prestaciones por periodo
mv_cantidad =
  MetodoDeValidacion.create!(
    {
      :nombre => "Verificar que no excede la cantidad máxima de prestaciones a pagar en un periodo de tiempo determinado",
      :metodo => "no_excede_la_cantidad_de_prestaciones_por_periodo?",
      :mensaje => "La prestación excede la tasa de uso definida",
      :genera_error => false
    }
  )

# Añado un método de validación para validar que los controles pediátricos no excedan la cantidad de prestaciones por periodo
# para la edad, y los parámetros necesarios para poder "tunear" el comportamiento del método sin tener que modificar el código
mv_control_pediatrico =
  MetodoDeValidacion.create!(
    {
      :nombre => "Verificar que no excede la cantidad máxima de prestaciones en el control de salud pediátrico",
      :metodo => "control_pediatrico_no_excede_la_cantidad_de_prestaciones_por_periodo?",
      :mensaje => "La prestación excede la tasa de uso definida",
      :genera_error => false
    }
  )
Parametro.create!([
  {
    :nombre => "TasaDeUsoControlPediatricoCantidadMaximaMenoresDe1Mes",
    :tipo_postgres => "int4",
    :tipo_ruby => "Integer",
    :valor => "2"
  },
  {
    :nombre => "TasaDeUsoControlPediatricoIntervaloMenoresDe1Mes",
    :tipo_postgres => "varchar(255)",
    :tipo_ruby => "String",
    :valor => "1.week"
  },
  {
    :nombre => "TasaDeUsoControlPediatricoCantidadMaximaDe1A6Meses",
    :tipo_postgres => "int4",
    :tipo_ruby => "Integer",
    :valor => "5"
  },
  {
    :nombre => "TasaDeUsoControlPediatricoIntervaloDe1A6Meses",
    :tipo_postgres => "varchar(255)",
    :tipo_ruby => "String",
    :valor => "2.weeks"
  },
  {
    :nombre => "TasaDeUsoControlPediatricoCantidadMaximaDe6A12Meses",
    :tipo_postgres => "int4",
    :tipo_ruby => "Integer",
    :valor => "3"
  },
  {
    :nombre => "TasaDeUsoControlPediatricoIntervaloDe6A12Meses",
    :tipo_postgres => "varchar(255)",
    :tipo_ruby => "String",
    :valor => "1.month"
  },
  {
    :nombre => "TasaDeUsoControlPediatricoCantidadMaximaDe12A18Meses",
    :tipo_postgres => "int4",
    :tipo_ruby => "Integer",
    :valor => "2"
  },
  {
    :nombre => "TasaDeUsoControlPediatricoIntervaloDe12A18Meses",
    :tipo_postgres => "varchar(255)",
    :tipo_ruby => "String",
    :valor => "2.months"
  },
  {
    :nombre => "TasaDeUsoControlPediatricoCantidadMaximaDe18A36Meses",
    :tipo_postgres => "int4",
    :tipo_ruby => "Integer",
    :valor => "3"
  },
  {
    :nombre => "TasaDeUsoControlPediatricoIntervaloDe18A36Meses",
    :tipo_postgres => "varchar(255)",
    :tipo_ruby => "String",
    :valor => "4.months"
  },
  {
    :nombre => "TasaDeUsoControlPediatricoCantidadMaximaDe36A72Meses",
    :tipo_postgres => "int4",
    :tipo_ruby => "Integer",
    :valor => "3"
  },
  {
    :nombre => "TasaDeUsoControlPediatricoIntervaloDe36A72Meses",
    :tipo_postgres => "varchar(255)",
    :tipo_ruby => "String",
    :valor => "8.months"
  }
])

prestacion = Prestacion.where(:codigo => "CTC005", :nombre => "Control prenatal de primera vez").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1,
    :periodo => "9.months",
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "CTC006", :nombre => "Consulta ulterior de control prenatal").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 4,
    :periodo => "9.months",
    :intervalo => "2.weeks"
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "CTC010", :nombre => "Consulta odontológica prenatal - Profilaxis").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1,
    :periodo => "9.months",
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "CTC010", :nombre => "Control odontológico en el tratamiento de la gingivitis y enfermedad periodontal leve en el embarazo").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 3,
    :periodo => "9.months",
    :intervalo => "1.week"
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "CTC007", :nombre => "Control prenatal de embarazo de alto riesgo de primera vez").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1, # VERIFICADO
    :periodo => "9.months",
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "CTC001", :nombre => "Consulta de puerperio inmediato").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1,
    :periodo => "9.months",
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "IMV010", :nombre => "Inmunización doble para adultos en el embarazo").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 2, # Revisar
    :periodo => "9.months",
    :intervalo => "1.month"
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "IMV013", :nombre => "Dosis aplicada de vacuna antigripal en el embarazo o puerperio").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 2, # Revisar
    :periodo => "9.months",
    :intervalo => "1.month"
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "IMV011", :nombre => "Inmunización puerperal doble viral (rubéola)").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1, # Revisar
    :periodo => "9.months",
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "PRP018", :nombre => "Toma de muestra para PAP (incluye material descartable)").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1,
    :periodo => "9.months",
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "PRP002", :nombre => "Colposcopía en control de embarazo (incluye material descartable)").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1,
    :periodo => "9.months",
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "PRP033", :nombre => "Tartrectomía y cepillado mecánico en el embarazo").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 4, # Revisar
    :periodo => "9.months",
    :intervalo => "1.week"
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "PRP026", :nombre => "Inactivación de caries en el embarazo").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 2, # Revisar
    :periodo => "9.months",
    :intervalo => "1.week"
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "LBL047", :nombre => "Laboratorio de prueba de embarazo - Gonadotrofina coriónica humana en sangre").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 2, # Revisar
    :periodo => "9.months",
    :intervalo => "1.week"
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "LBL048", :nombre => "Laboratorio de prueba de embarazo - Gonadotrofina coriónica humana en orina").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 2, # Revisar
    :periodo => "9.months",
    :intervalo => "1.week"
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "LBL050", :nombre => "Laboratorio de control prenatal de primera vez - Grupo y factor").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1,
    :periodo => "9.months",
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "LBL055", :nombre => "Laboratorio de control prenatal de primera vez - Hemoglobina").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1,
    :periodo => "9.months",
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "LBL045", :nombre => "Laboratorio de control prenatal de primera vez - Glucemia").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1,
    :periodo => "9.months",
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "LBL079", :nombre => "Laboratorio de control prenatal de primera vez - Orina completa").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1,
    :periodo => "9.months",
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "LBL119", :nombre => "Laboratorio de control prenatal de primera vez - VDRL").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1,
    :periodo => "9.months",
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "LBL065", :nombre => "Laboratorio de control prenatal de primera vez - IFI y hemoaglutinación directa para Chagas").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1,
    :periodo => "9.months",
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "LBL080", :nombre => "Laboratorio de control prenatal de primera vez - Parasitemia para Chagas").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1,
    :periodo => "9.months",
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "LBL099", :nombre => "Laboratorio de control prenatal de primera vez - Serología para Chagas (ELISA)").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1,
    :periodo => "9.months",
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "LBL128", :nombre => "Laboratorio de control prenatal de primera vez - Hemoaglutinación indirecta para Chagas").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1,
    :periodo => "9.months",
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "LBL121", :nombre => "Laboratorio de control prenatal de primera vez - VIH ELISA").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1,
    :periodo => "9.months",
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "LBL122", :nombre => "Laboratorio de control prenatal de primera vez - VIH Western Blot").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1,
    :periodo => "9.months",
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "LBL110", :nombre => "Laboratorio de control prenatal de primera vez - Toxoplasmosis por IFI").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1,
    :periodo => "9.months",
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "LBL111", :nombre => "Laboratorio de control prenatal de primera vez - Toxoplasmosis por MEIA").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1,
    :periodo => "9.months",
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "LBL051", :nombre => "Laboratorio de control prenatal de primera vez - Hbs antígeno").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1,
    :periodo => "9.months",
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "LBL055", :nombre => "Laboratorio ulterior de control prenatal - Hemoglobina").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1,
    :periodo => "9.months",
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "LBL045", :nombre => "Laboratorio ulterior de control prenatal - Glucemia").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1,
    :periodo => "9.months",
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "LBL079", :nombre => "Laboratorio ulterior de control prenatal - Orina completa").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1,
    :periodo => "9.months",
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "LBL119", :nombre => "Laboratorio ulterior de control prenatal - VDRL").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1,
    :periodo => "9.months",
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "LBL121", :nombre => "Laboratorio ulterior de control prenatal - VIH ELISA").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1,
    :periodo => "9.months",
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "LBL122", :nombre => "Laboratorio ulterior control prenatal - VIH Western Blot").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1,
    :periodo => "9.months",
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "COT017", :nombre => "Consejería puerperal en salud sexual y reproductiva, lactancia materna y puericultura (prevención de muerte súbita y signos de alarma)").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 2,
    :periodo => "9.months",
    :intervalo => "1.week"
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "COT019", :nombre => "Carta de derechos de la mujer embarazada indígena").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1,
    :periodo => "9.months",
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "COT021", :nombre => "Educación para la salud en el embarazo (bio-psico-social)").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1,
    :periodo => "9.months",
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "ROX001", :nombre => "Ronda sanitaria completa orientada a la detección de población de riesgo en área rural").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1,
    :periodo => "4.months",
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "ROX002", :nombre => "Ronda sanitaria completa orientada a la detección de población de riesgo en población indígena").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1,
    :periodo => "4.months",
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "CAW001", :nombre => "Búsqueda activa de embarazadas en el primer trimestre por agente sanitario y/o personal de salud").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1,
    :periodo => "9.months",
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "CAW002", :nombre => "Búsqueda activa de embarazadas con abandono de controles, por agente sanitario y/o personal de salud").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1,
    :periodo => "9.months",
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "AUH001", :nombre => "Informe del comité de auditoría de muerte materna, recibido y aprobado por el Ministerio de Salud de la provincia, según ordenamiento").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1,
    :periodo => nil,
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "CTC005", :nombre => "Atención y tratamiento ambulatorio de anemia leve del embarazo (primera vez)").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1,
    :periodo => "9.months",
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "CTC006", :nombre => "Atención y tratamiento ambulatorio de anemia leve del embarazo (ulterior)").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 3, # Revisar
    :periodo => "9.months",
    :intervalo => "1.month"
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "CTC007", :nombre => "Atención y tratamiento ambulatorio de anemia grave del embarazo (no incluye hemoderivados)").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 3, # Revisar
    :periodo => "9.months",
    :intervalo => "1.month"
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "CTC007", :nombre => "Tratamiento de la hemorragia del primer trimestre").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 2, # Revisar
    :periodo => "3.months",
    :intervalo => "2.days"
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "ITE004", :nombre => "Tratamiento de la hemorragia del primer trimestre (clínica obstétrica)").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 2, # Revisar
    :periodo => "3.months",
    :intervalo => "2.days"
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "ITQ005", :nombre => "Tratamiento de la hemorragia del primer trimestre (quirúrgica)").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1, # Revisar
    :periodo => "3.months",
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "ITE005", :nombre => "Tratamiento de la hemorragia del segundo trimestre (clínica obstétrica)").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 2, # Revisar
    :periodo => "6.months", # No pongo 3 porque tienen que transcurrir unos 6 meses entre embarazo y embarazo
    :intervalo => "2.days"
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "ITQ006", :nombre => "Tratamiento de la hemorragia del segundo trimestre (quirúrgica)").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1, # Revisar
    :periodo => "6.months",
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "ITE006", :nombre => "Tratamiento de la hemorragia del tercer trimestre (clínica obstétrica)").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 2, # Revisar
    :periodo => "9.months",
    :intervalo => "2.days"
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "ITQ007", :nombre => "Tratamiento de la hemorragia del tercer trimestre (quirúrgica)").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1, # Revisar
    :periodo => "9.months",
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "CTC005", :nombre => "Atención y tratamiento ambulatorio de infección urinaria en el embarazo").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 2, # Revisar
    :periodo => "9.months",
    :intervalo => "1.month"
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "CTC007", :nombre => "Atención y tratamiento ambulatorio de sífilis e ITS en el embarazo").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 2, # Revisar
    :periodo => "9.months",
    :intervalo => "1.month"
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "CTC007", :nombre => "Atención y tratamiento ambulatorio de VIH en el embarazo").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 2, # Revisar
    :periodo => "9.months",
    :intervalo => "1.month"
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "APA001", :nombre => "Lectura de muestra tomada en mujeres embarazadas, en laboratorio de Anatomía patológica/Citología, firmado por anátomo-patólogo matriculado (CA cérvico-uterino)").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1,
    :periodo => "9.months",
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "ITQ001", :nombre => "Atención de parto y recién nacido").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1,
    :periodo => "9.months",
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "ITQ002", :nombre => "Cesárea y atención de recién nacido").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1,
    :periodo => "9.months",
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "CTC018", :nombre => "Tratamiento ambulatorio de complicaciones del parto en el puerperio inmediato (primera vez)").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1,
    :periodo => "9.months",
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "CTC019", :nombre => "Tratamiento ambulatorio de complicaciones del parto en el puerperio inmediato (ulterior)").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 2, # Revisar
    :periodo => "9.months",
    :intervalo => "2.days"
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "PRP004", :nombre => "Electrocardiograma en embarazo").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1, # Revisar
    :periodo => "9.months",
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "TLM081", :nombre => "Transporte por referencia de embarazadas de zona A (hasta 50 km)").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1, # Revisar
    :periodo => "9.months",
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "TLM082", :nombre => "Transporte por referencia de embarazadas de zona B (más de 50 km)").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1, # Revisar
    :periodo => "9.months",
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "IGR031", :nombre => "Ecografía en control prenatal").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 2, # Revisar
    :periodo => "9.months",
    :intervalo => "1.month"
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "IGR022", :nombre => "Rx de cráneo (frente y perfil) en embarazadas").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1, # Revisar
    :periodo => "9.months",
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "NTN004", :nombre => "Notificación de factores de riesgo").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1, # Revisar
    :periodo => "9.months",
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "NTN006", :nombre => "Referencia por embarazo de alto riesgo de nivel 2 o 3 a niveles de complejidad superior").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1, # Revisar
    :periodo => "9.months",
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "IMV012", :nombre => "Inmunización del recién nacido: BCG antes del alta").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1, # Revisar
    :periodo => nil,
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "IMV009", :nombre => "Inmunización del recién nacido: anti-hepatitis B").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1, # Revisar
    :periodo => nil,
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "AUH002", :nombre => "Informe del comité de auditoría de muerte infantil recibido y aprobado por el Ministerio de Salud de la provincia, según ordenamiento").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1,
    :periodo => nil,
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "PRP021", :nombre => "Otoemisiones acústicas para detección temprana de hipoacusia en recién nacidos").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1,
    :periodo => nil,
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "ITE002", :nombre => "Tratamiento inmediato de sífilis congénita en el recién nacido").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1,
    :periodo => nil,
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "ITE002", :nombre => "Tratamiento inmediato de transmisión vertical del VIH en el recién nacido").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1,
    :periodo => nil,
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "ITE002", :nombre => "Tratamiento inmediato de Chagas congénito en el recién nacido").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1,
    :periodo => nil,
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "ITE002", :nombre => "Atención de recién nacido con condición grave al nacer (tratamiento de pre-referencia)").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1,
    :periodo => nil,
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "ICI001", :nombre => "Incubadora hasta 48 horas en recién nacidos").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1,
    :periodo => nil,
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "PRP017", :nombre => "Pesquisa de retinopatía del prematuro: Oftalmoscopía binocular indirecta (OBI) a niñas y niños de riesgo").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1,
    :periodo => nil,
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "ITE002", :nombre => "Tratamiento inmediato de trastornos metabólicos (estado ácido base y electrolitos) en el recién nacido").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1,
    :periodo => nil,
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "CTC001", :nombre => "Consulta pediátrica en menores de un año").first
prestacion.metodos_de_validacion << mv_control_pediatrico

prestacion = Prestacion.where(:codigo => "CTC001", :nombre => "Consulta pediátrica de 1 a 5 años").first
prestacion.metodos_de_validacion << mv_control_pediatrico

prestacion = Prestacion.where(:codigo => "CTC010", :nombre => "Consulta de salud buco-dental en niños menores de 6 años").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1,
    :periodo => "1.year",
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "CTC011", :nombre => "Consulta oftalmológica en niños de 5 años").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1,
    :periodo => nil,
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:id => 467, :codigo => "CAW003", :nombre => "Búsqueda activa de niñas y niños con abandono de controles por agente sanitario o personal de salud").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1,
    :periodo => nil,
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "CTC016", :nombre => "Consulta con pediatra especialista en cardiología, nefrología, infectología, gastroenterología").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1,
    :periodo => "1.year",
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "CTC001", :nombre => "Atención ambulatoria con suplementación vitamínica a niños desnutridos menores de 6 años (inicial)").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1,
    :periodo => "1.year",
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "CTC002", :nombre => "Atención ambulatoria con suplementación vitamínica a niños desnutridos menores de 6 años (ulterior)").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 5,
    :periodo => "1.year",
    :intervalo => "1.month"
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "CTC001", :nombre => "Atención ambulatoria de infección respiratoria aguda en niños menores de 6 años (inicial)").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1,
    :periodo => "1.year",
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "CTC002", :nombre => "Atención ambulatoria de infección respiratoria aguda en niños menores de 6 años (ulterior)").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 5,
    :periodo => "1.year",
    :intervalo => "1.month"
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "PRP011", :nombre => "Kinesioterapia ambulatoria en infecciones respiratorias agudas en niños menores de 6 años (5 sesiones)").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 5,
    :periodo => "1.year",
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "ITE001", :nombre => "Internación abreviada de síndrome bronquial obstructivo (prehospitalización en ambulatorio)").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1,
    :periodo => "1.year",
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "ITE002", :nombre => "Internación abreviada de síndrome bronquial obstructivo (24 a 48 horas de internación en hospital)").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1,
    :periodo => "1.year",
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "ITE003", :nombre => "Internación por neumonía").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1,
    :periodo => "1.year",
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "CTC001", :nombre => "Consulta de niños con especialistas (hipoacusia en lactante \"No pasa\" con otoemisiones acústicas)").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 3,
    :periodo => "1.year",
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "PRP022", :nombre => "Rescreening de hipoacusia en lactante \"No pasa\" con BERA").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 2,
    :periodo => nil,
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "PRP021", :nombre => "Rescreening de hipoacusia en lactante \"No pasa\" con otoemisiones acústicas").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 2,
    :periodo => nil,
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "CTC001", :nombre => "Atención ambulatoria de enfermedades diarreicas agudas en niños menores de 6 años (inicial)").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1,
    :periodo => "1.year",
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "CTC002", :nombre => "Atención ambulatoria de enfermedades diarreicas agudas en niños menores de 6 años (ulterior)").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 2,
    :periodo => "1.year",
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "ITE001", :nombre => "Posta de rehidratación: diarrea aguda en ambulatorio").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1,
    :periodo => "1.year",
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "CTC012", :nombre => "Consulta pediátrica de menores de 6 años en emergencia hospitalaria").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1,
    :periodo => "1.year",
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:id => 484, :codigo => "PRP026", :nombre => "Inactivación de caries").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 3,
    :periodo => "1.year",
    :intervalo => "1.week"
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "PRP004", :nombre => "Electrocardiograma en niños menores de 6 años").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1,
    :periodo => "1.year",
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "TLM081", :nombre => "Transporte por referencia de niños menores de 6 años de zona A (hasta 50 km)").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 3,
    :periodo => "1.year",
    :intervalo => "1.week"
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "TLM082", :nombre => "Transporte por referencia de niños menores de 6 años de zona B (más de 50 km)").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 3,
    :periodo => "1.year",
    :intervalo => "1.week"
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "IGR005", :nombre => "Ecografía bilateral de cadera en niños menores de 2 meses").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1,
    :periodo => nil,
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "IGR026", :nombre => "Rx de tórax frente y perfil en niños menores de 6 años").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 3,
    :periodo => "1.year",
    :intervalo => "1.month"
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "IGR022", :nombre => "Rx de cráneo frente y perfil en niños menores de 6 años").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 2,
    :periodo => "1.year",
    :intervalo => "1.month"
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "IGR017", :nombre => "Rx de huesos cortos, frente y perfil, en niños menores de 6 años con patología prevalente").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 2,
    :periodo => "1.year",
    :intervalo => "1.month"
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "IGR025", :nombre => "Rx de huesos largos, frente y perfil, en niños menores de 6 años con patología prevalente").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 2,
    :periodo => "1.year",
    :intervalo => "1.month"
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "IGR004", :nombre => "Ecodoppler en niños menores de 6 años").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 2,
    :periodo => "1.year",
    :intervalo => "1.month"
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "CTC001", :nombre => "Control en niños y niñas de 6 a 9 años").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1,
    :periodo => "1.year",
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:id => 494, :codigo => "CTC009", :nombre => "Control de salud individual para población indígena en terreno").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1,
    :periodo => "1.year",
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:id => 495, :codigo => "CTC010", :nombre => "Control odontológico").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1,
    :periodo => "1.year",
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:id => 496, :codigo => "CTC011", :nombre => "Control oftalmológico").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1,
    :periodo => "1.year",
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:id => 497, :codigo => "CAW003", :nombre => "Búsqueda activa de niñas y niños con abandono de controles por agente sanitario o personal de salud").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1,
    :periodo => "1.year",
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:id => 498, :codigo => "CAW006", :nombre => "Consulta para confirmación diagnóstica en población indígena con riesgo detectado en terreno").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1,
    :periodo => "1.year",
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:id => 505, :codigo => "PRP026", :nombre => "Inactivación de caries").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 2,
    :periodo => "1.year",
    :intervalo => "1.week"
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "PRP025", :nombre => "Barniz fluorado de surcos").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 2,
    :periodo => "1.year",
    :intervalo => "1.week"
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "PRP024", :nombre => "Sellado de surcos").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 2,
    :periodo => "1.year",
    :intervalo => "1.week"
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "CTC001", :nombre => "Anemia leve y moderada (inicial)").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1,
    :periodo => "1.year",
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "CTC002", :nombre => "Anemia leve y moderada (ulterior)").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 3,
    :periodo => "1.year",
    :intervalo => "1.month"
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "CTC001", :nombre => "Asma bronquial (inicial)").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1,
    :periodo => "1.year",
    :intervalo => "1.month"
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:id => 511, :codigo => "CTC012", :nombre => "Asma bronquial (urgencia)").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 2,
    :periodo => "1.year",
    :intervalo => "1.month"
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:id => 512, :codigo => "CTC001", :nombre => "Consulta diagnóstica y de seguimiento de leucemia (inicial)").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1,
    :periodo => "1.year",
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:id => 513, :codigo => "CTC002", :nombre => "Consulta diagnóstica y de seguimiento de leucemia (ulterior)").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 5,
    :periodo => "1.year",
    :intervalo => "1.month"
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:id => 514, :codigo => "CTC001", :nombre => "Consulta diagnóstica y de seguimiento de linfoma (inicial)").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1,
    :periodo => "1.year",
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:id => 515, :codigo => "CTC002", :nombre => "Consulta diagnóstica y de seguimiento de linfoma (ulterior)").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 5,
    :periodo => "1.year",
    :intervalo => "1.month"
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "CTC001", :nombre => "Consulta de obesidad (inicial)").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1,
    :periodo => "1.year",
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "CTC002", :nombre => "Consulta de obesidad (ulterior)").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 3,
    :periodo => "1.year",
    :intervalo => "1.month"
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "CTC001", :nombre => "Consulta de sobrepeso (inicial)").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1,
    :periodo => "1.year",
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "CTC002", :nombre => "Consulta de sobrepeso (ulterior)").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 3,
    :periodo => "1.year",
    :intervalo => "1.month"
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "NTN002", :nombre => "Notificación de inicio de tratamiento en tiempo oportuno (leucemia/linfoma)").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1,
    :periodo => "1.year",
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "CTC001", :nombre => "Examen periódico de salud del adolescente").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1,
    :periodo => "1.year",
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:id => 522, :codigo => "CTC009", :nombre => "Control de salud individual para población indígena en terreno").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1,
    :periodo => "1.year",
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:id => 523, :codigo => "CTC008", :nombre => "Control ginecológico").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1,
    :periodo => "1.year",
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "CTC010", :nombre => "Consulta odontológica").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1,
    :periodo => "1.year",
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:id => 525, :codigo => "CTC011", :nombre => "Control oftalmológico").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1,
    :periodo => "1.year",
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:id => 532, :codigo => "COT018", :nombre => "Consejería post-aborto").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1,
    :periodo => "1.year",
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "COT016", :nombre => "Consejería en salud sexual (en terreno)").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1,
    :periodo => "1.year",
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "COT015", :nombre => "Consejería en salud sexual para adolescentes").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1,
    :periodo => "1.year",
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "CAW005", :nombre => "Búsqueda activa de adolescentes para valoración integral").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1,
    :periodo => "1.year",
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "CAW004", :nombre => "Búsqueda activa de embarazadas adolescentes por agente sanitario o personal de salud").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1,
    :periodo => "1.year",
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:id => 537, :codigo => "CAW006", :nombre => "Consulta para confirmación diagnóstica en población indígena con riesgo detectado en terreno").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1,
    :periodo => "1.year",
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "CTC001", :nombre => "Anemia leve y moderada en mujeres (inicial)").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1,
    :periodo => "1.year",
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "CTC002", :nombre => "Anemia leve y moderada en mujeres (ulterior)").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 3,
    :periodo => "1.year",
    :intervalo => "1.month"
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:id => 540, :codigo => "CTC012", :nombre => "Asma bronquial (urgencia)").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1,
    :periodo => "1.year",
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:id => 541, :codigo => "CTC001", :nombre => "Asma bronquial (inicial)").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 1,
    :periodo => "1.year",
    :intervalo => nil
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:id => 542, :codigo => "CTC002", :nombre => "Asma bronquial (ulterior)").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 3,
    :periodo => "1.year",
    :intervalo => "1.month"
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "CTC012", :nombre => "Consumo episódico excesivo de alcohol y/u otras sustancias psicoactivas (urgencia/consultorio externo)").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 2,
    :periodo => "1.year",
    :intervalo => "1.month"
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:codigo => "CTC012", :nombre => "Intento de suicidio (urgencia)").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 2,
    :periodo => "1.year",
    :intervalo => "1.month"
  }
)
prestacion.metodos_de_validacion << mv_cantidad

prestacion = Prestacion.where(:id => 545, :codigo => "CTC012", :nombre => "Víctima de violencia sexual (urgencia)").first
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 2,
    :periodo => "1.year",
    :intervalo => "1.month"
  }
)
prestacion.metodos_de_validacion << mv_cantidad
