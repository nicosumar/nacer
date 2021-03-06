# -*- encoding : utf-8 -*-
# Modificar el Inflector para generar inflexiones en español
module ActiveSupport
  module Inflector

      def pluralize(word)
        result = word.to_s.dup

        if word.empty? || inflections.uncountables.include?(result.downcase)
          result
        else
          inflections.plurals.each { |(rule, replacement)| result.gsub!(rule, replacement) }
          result
        end
      end

      def singularize(word)
        result = word.to_s.dup

        if inflections.uncountables.any? { |inflection| result =~ /\b(#{inflection})\Z/i }
          result
        else
          inflections.singulars.each { |(rule, replacement)| result.gsub!(rule, replacement) }
          result
        end
    end
  end
end

ActiveSupport::Inflector.inflections do |inflect|

  inflect.clear(:all)

  inflect.plural(/·([A-Z]|_| |$)/, '\1')
  inflect.plural(/([acefgikoptuw])([A-Z]|_| |$)/, '\1s\2')
  inflect.plural(/z([A-Z]|_| |$)/, 'ces\1')
  inflect.plural(/([bdhjlmnrsy])([A-Z]|_| |$)/, '\1es\2')

  inflect.singular(/·([A-Z]|_| |$)/, '\1')
  inflect.singular(/([acefgikoptuw])s([A-Z]|_| |$)/, '\1\2')
  inflect.singular(/ces([A-Z]|_| |$)/, 'z\1')
  inflect.singular(/([bdhjlmnrsy])es([A-Z]|_| |$)/, '\1\2')

  # Inflexiones en inglés para Authlogic y CanCan
  inflect.irregular("user", "users·")
  inflect.irregular("user·", "users")
  inflect.irregular("session", "sessions·")
  inflect.irregular("session·", "sessions")
  inflect.irregular("user_group", "user·_groups·")
  inflect.irregular("user·_group·", "user_groups")
  inflect.irregular("UserGroup", "User·Groups·")
  inflect.irregular("User·Group·", "UserGroups")
  inflect.irregular("user_session", "user·_sessions·")
  inflect.irregular("user·_session·", "user_sessions")
  inflect.irregular("UserSession", "User·Sessions·")
  inflect.irregular("User·Session·", "UserSessions")
  inflect.irregular("user_group_user", "user·_groups·_users·")
  inflect.irregular("user·_group·_user·", "user_groups_users")
  inflect.irregular("UserGroupUser", "User·Groups·Users·")
  inflect.irregular("User·Group·User·", "UserGroupsUsers")
  inflect.irregular("ability", "abilities·")
  inflect.irregular("ability·", "abilities")

  # Plurales no regulares para clases y objetos

  inflect.irregular("convenio_de_gestion", "convenios·_de·_gestion·")
  inflect.irregular("convenio·_de·_gestion·", "convenios_de_gestion")
  inflect.irregular("ConvenioDeGestion", "Convenios·De·Gestion·")
  inflect.irregular("Convenio·De·Gestion·", "ConveniosDeGestion")
  inflect.irregular("convenio_de_administracion", "convenios·_de·_administracion·")
  inflect.irregular("convenio·_de·_administracion·", "convenios_de_administracion")
  inflect.irregular("ConvenioDeAdministracion", "Convenios·De·Administracion·")
  inflect.irregular("Convenio·De·Administracion·", "ConveniosDeAdministracion")
  inflect.irregular("grupo_de_efectores", "grupos·_de·_efectores·")
  inflect.irregular("grupo·_de·_efectores·", "grupos_de_efectores")
  inflect.irregular("GrupoDeEfectores", "Grupos·De·Efectores·")
  inflect.irregular("Grupo·De·Efectores·", "GruposDeEfectores")
  inflect.irregular("area_de_prestacion", "areas·_de·_prestacion·")
  inflect.irregular("area·_de·_prestacion·", "areas_de_prestacion")
  inflect.irregular("AreaDePrestacion", "Areas·De·Prestacion·")
  inflect.irregular("Area·De·Prestacion·", "AreasDePrestacion")
  inflect.irregular("grupo_de_prestaciones", "grupos·_de·_prestaciones·")
  inflect.irregular("grupo·_de·_prestaciones·", "grupos_de_prestaciones")
  inflect.irregular("GrupoDePrestaciones", "Grupos·De·Prestaciones·")
  inflect.irregular("Grupo·De·Prestaciones·", "GruposDePrestaciones")
  inflect.irregular("subgrupo_de_prestaciones", "subgrupos·_de·_prestaciones·")
  inflect.irregular("subgrupo·_de·_prestaciones·", "subgrupos_de_prestaciones")
  inflect.irregular("SubgrupoDePrestaciones", "Subgrupos·De·Prestaciones·")
  inflect.irregular("Subgrupo·De·Prestaciones·", "SubgruposDePrestaciones")
  inflect.irregular("unidad_de_medida", "unidades·_de·_medida·")
  inflect.irregular("unidad·_de·_medida·", "unidades_de_medida")
  inflect.irregular("UnidadDeMedida", "Unidades·De·Medida·")
  inflect.irregular("Unidad·De·Medida·", "UnidadesDeMedida")

  inflect.irregular("asignacion_de_precios", "asignaciones·_de·_precios·")
  inflect.irregular("asignacion·_de·_precios·", "asignaciones_de_precios")
  inflect.irregular("AsignacionDePrecios", "Asignaciones·De·Precios·")
  inflect.irregular("Asignacion·De·Precios·", "AsignacionesDePrecios")

  inflect.irregular("asignaciones_de_precios", "asignaciones·_de·_precios·")
  inflect.irregular("asignaciones·_de·_precios·", "asignaciones_de_precios")
  inflect.irregular("AsignacionesDePrecios", "Asignaciones·De·Precios·")
  inflect.irregular("Asignaciones·De·Precios·", "AsignacionesDePrecios")



  inflect.irregular("asignacion_de_nomenclador", "asignaciones·_de·_nomenclador·")
  inflect.irregular("asignacion·_de·_nomenclador·", "asignaciones_de_nomenclador")
  inflect.irregular("AsignacionDeNomenclador", "Asignaciones·De·Nomenclador·")
  inflect.irregular("Asignacion·De·Nomenclador·", "AsignacionesDeNomenclador")
  inflect.irregular("categoria_de_afiliado", "categorias·_de·_afiliados·")
  inflect.irregular("categoria·_de·_afiliado·", "categorias_de_afiliados")
  inflect.irregular("CategoriaDeAfiliado", "Categorias·De·Afiliados·")
  inflect.irregular("Categoria·De·Afiliado·", "CategoriasDeAfiliados")
  inflect.irregular("periodo_de_actividad", "periodos·_de·_actividad·")
  inflect.irregular("periodo·_de·_actividad·", "periodos_de_actividad")
  inflect.irregular("PeriodoDeActividad", "Periodos·De·Actividad·")
  inflect.irregular("Periodo·De·Actividad·", "PeriodosDeActividad")
  inflect.irregular("cuasi_factura", "cuasi·_facturas·")
  inflect.irregular("cuasi·_factura·", "cuasi_facturas")
  inflect.irregular("CuasiFactura", "Cuasi·Facturas·")
  inflect.irregular("Cuasi·Factura·", "CuasiFacturas")
  inflect.irregular("renglon_de_cuasi_factura", "renglones·_de·_cuasi·_facturas·")
  inflect.irregular("renglon·_de·_cuasi·_factura·", "renglones_de_cuasi_facturas")
  inflect.irregular("RenglonDeCuasiFactura", "Renglones·De·Cuasi·Facturas·")
  inflect.irregular("Renglon·De·Cuasi·Factura·", "RenglonesDeCuasiFacturas")
  inflect.irregular("registro_de_prestacion", "registros·_de·_prestaciones·")
  inflect.irregular("registro·_de·_prestacion·", "registros_de_prestaciones")
  inflect.irregular("RegistroDePrestacion", "Registros·De·Prestaciones·")
  inflect.irregular("Registro·De·Prestacion·", "RegistrosDePrestaciones")
  inflect.irregular("clase_de_documento", "clases·_de·_documentos·")
  inflect.irregular("clase·_de·_documento·", "clases_de_documentos")
  inflect.irregular("ClaseDeDocumento", "Clases·De·Documentos·")
  inflect.irregular("Clase·De·Documento·", "ClasesDeDocumentos")
  inflect.irregular("tipo_de_documento", "tipos·_de·_documentos·")
  inflect.irregular("tipo·_de·_documento·", "tipos_de_documentos")
  inflect.irregular("TipoDeDocumento", "Tipos·De·Documentos·")
  inflect.irregular("Tipo·De·Documento·", "TiposDeDocumentos")
#  inflect.irregular("tipo_de_requerimiento", "tipos·_de·_requerimiento·")
#  inflect.irregular("tipo·_de·_requerimiento·", "tipos_de_requerimiento")
#  inflect.irregular("TipoDeRequerimiento", "Tipos·De·Requerimiento·")
#  inflect.irregular("Tipo·De·Requerimiento·", "TiposDeRequerimiento")
  inflect.irregular("dato_adicional", "datos·_adicionales·")
  inflect.irregular("dato·_adicional·", "datos_adicionales")
  inflect.irregular("DatoAdicional", "Datos·Adicionales·")
  inflect.irregular("Dato·Adicional·", "DatosAdicionales")
  inflect.irregular("dato_adicional_por_prestacion", "datos·_adicionales·_por·_prestacion·")
  inflect.irregular("dato·_adicional·_por·_prestacion·", "datos_adicionales_por_prestacion")
  inflect.irregular("DatoAdicionalPorPrestacion", "Datos·Adicionales·Por·Prestacion·")
  inflect.irregular("Dato·Adicional·Por·Prestacion·", "DatosAdicionalesPorPrestacion")
  inflect.irregular("estado_de_la_prestacion", "estados·_de·_las·_prestaciones·")
  inflect.irregular("estado·_de·_la·_prestacion·", "estados_de_las_prestaciones")
  inflect.irregular("EstadoDeLaPrestacion", "Estados·De·Las·Prestaciones·")
  inflect.irregular("Estado·De·La·Prestacion·", "EstadosDeLasPrestaciones")
  inflect.irregular("motivo_de_rechazo", "motivos·_de·_rechazos·")
  inflect.irregular("motivo·_de·_rechazo·", "motivos_de_rechazos")
  inflect.irregular("MotivoDeRechazo", "Motivos·De·Rechazos·")
  inflect.irregular("Motivo·De·Rechazo·", "MotivosDeRechazos")
  inflect.irregular("registro_de_dato_adicional", "registros·_de·_datos·_adicionales·")
  inflect.irregular("registro·_de·_dato·_adicional·", "registros_de_datos_adicionales")
  inflect.irregular("RegistroDeDatoAdicional", "Registros·De·Datos·Adicionales·")
  inflect.irregular("Registro·De·Dato·Adicional·", "RegistrosDeDatosAdicionales")
  inflect.irregular("percentil_peso_edad", "percentiles·_peso·_edad·")
  inflect.irregular("percentil·_peso·_edad·", "percentiles_peso_edad")
  inflect.irregular("PercentilPesoEdad", "Percentiles·Peso·Edad·")
  inflect.irregular("Percentil·Peso·Edad·", "PercentilesPesoEdad")
  inflect.irregular("percentil_peso_talla", "percentiles·_peso·_talla·")
  inflect.irregular("percentil·_peso·_talla·", "percentiles_peso_talla")
  inflect.irregular("PercentilPesoTalla", "Percentiles·Peso·Talla·")
  inflect.irregular("Percentil·Peso·Talla·", "PercentilesPesoTalla")
  inflect.irregular("si_no", "si·_no·")
  inflect.irregular("si·_no·", "si_no")
  inflect.irregular("SiNo", "Si·No·")
  inflect.irregular("Si·No·", "SiNo")
  inflect.irregular("percentil_pc_edad", "percentiles·_pc·_edad·")
  inflect.irregular("percentil·_pc·_edad·", "percentiles_pc_edad")
  inflect.irregular("PercentilPcEdad", "Percentiles·Pc·Edad·")
  inflect.irregular("Percentil·Pc·Edad·", "PercentilesPcEdad")
  inflect.irregular("percentil_talla_edad", "percentiles·_talla·_edad·")
  inflect.irregular("percentil·_talla·_edad·", "percentiles_talla_edad")
  inflect.irregular("PercentilTallaEdad", "Percentiles·Talla·Edad·")
  inflect.irregular("Percentil·Talla·Edad·", "PercentilesTallaEdad")
  inflect.irregular("novedad_del_afiliado", "novedades·_de·_los·_afiliados·")
  inflect.irregular("novedad·_del·_afiliado·", "novedades_de_los_afiliados")
  inflect.irregular("NovedadDelAfiliado", "Novedades·De·Los·Afiliados·")
  inflect.irregular("Novedad·Del·Afiliado·", "NovedadesDeLosAfiliados")
  inflect.irregular("tipo_de_novedad", "tipos·_de·_novedades·")
  inflect.irregular("tipo·_de·_novedad·", "tipos_de_novedades")
  inflect.irregular("TipoDeNovedad", "Tipos·De·Novedades·")
  inflect.irregular("Tipo·De·Novedad·", "TiposDeNovedades")
  inflect.irregular("centro_de_inscripcion", "centros·_de·_inscripcion·")
  inflect.irregular("centro·_de·_inscripcion·", "centros_de_inscripcion")
  inflect.irregular("CentroDeInscripcion", "Centros·De·Inscripcion·")
  inflect.irregular("Centro·De·Inscripcion·", "CentrosDeInscripcion")
  inflect.irregular("estado_de_la_novedad", "estados·_de·_las·_novedades·")
  inflect.irregular("estado·_de·_la·_novedad·", "estados_de_las_novedades")
  inflect.irregular("EstadoDeLaNovedad", "Estados·De·Las·Novedades·")
  inflect.irregular("Estado·De·La·Novedad·", "EstadosDeLasNovedades")
  inflect.irregular("tipo_de_relacion", "tipos·_de·_relaciones·")
  inflect.irregular("tipo·_de·_relacion·", "tipos_de_relaciones")
  inflect.irregular("TipoDeRelacion", "Tipos·De·Relaciones·")
  inflect.irregular("Tipo·De·Relacion·", "TiposDeRelaciones")
  inflect.irregular("nivel_de_instruccion", "niveles·_de·_instruccion·")
  inflect.irregular("nivel·_de·_instruccion·", "niveles_de_instruccion")
  inflect.irregular("NivelDeInstruccion", "Niveles·De·Instruccion·")
  inflect.irregular("Nivel·De·Instruccion·", "NivelesDeInstruccion")
  inflect.irregular("busqueda_de_afiliado", "busquedas·_de·_afiliados·")
  inflect.irregular("busqueda·_de·_afiliado·", "busquedas_de_afiliados")
  inflect.irregular("BusquedaDeAfiliado", "Busquedas·De·Afiliados·")
  inflect.irregular("Busqueda·De·Afiliado·", "BusquedasDeAfiliados")
  inflect.irregular("resultado_de_la_busqueda", "resultados·_de·_la·_busqueda·")
  inflect.irregular("resultado·_de·_la·_busqueda·", "resultados_de_la_busqueda")
  inflect.irregular("ResultadoDeLaBusqueda", "Resultados·De·La·Busqueda·")
  inflect.irregular("Resultado·De·La·Busqueda·", "ResultadosDeLaBusqueda")
  inflect.irregular("unidad_de_alta_de_datos", "unidades·_de·_alta·_de·_datos·")
  inflect.irregular("unidad·_de·_alta·_de·_datos·", "unidades_de_alta_de_datos")
  inflect.irregular("UnidadDeAltaDeDatos", "Unidades·De·Alta·De·Datos·")
  inflect.irregular("Unidad·De·Alta·De·Datos·", "UnidadesDeAltaDeDatos")
  inflect.irregular("unidad_de_alta_de_datos_user", "unidades·_de·_alta·_de·_datos·_users·")
  inflect.irregular("unidad·_de·_alta·_de·_datos·_user", "unidades_de_alta_de_datos_users")
  inflect.irregular("UnidadDeAltaDeDatosUser", "Unidades·De·Alta·De·Datos·Users·")
  inflect.irregular("Unidad·De·Alta·De·Datos·User·", "UnidadesDeAltaDeDatosUsers")
  inflect.irregular("tipo_de_prestacion", "tipos·_de·_prestaciones·")
  inflect.irregular("tipo·_de·_prestacion·", "tipos_de_prestaciones")
  inflect.irregular("TipoDePrestacion", "Tipos·De·Prestaciones·")
  inflect.irregular("Tipo·De·Prestacion·", "TiposDePrestaciones")
  inflect.irregular("periodo_de_cobertura", "periodos·_de·_cobertura·")
  inflect.irregular("periodo·_de·_cobertura·", "periodos_de_cobertura")
  inflect.irregular("PeriodoDeCobertura", "Periodos·De·Cobertura·")
  inflect.irregular("Periodo·De·Cobertura·", "PeriodosDeCobertura")
  inflect.irregular("periodo_de_capita", "periodos·_de·_capita·")
  inflect.irregular("periodo·_de·_capita·", "periodos_de_capita")
  inflect.irregular("PeriodoDeCapita", "Periodos·De·Capita·")
  inflect.irregular("Periodo·De·Capita·", "PeriodosDeCapita")
  inflect.irregular("periodo_de_embarazo", "periodos·_de·_embarazo·")
  inflect.irregular("periodo·_de·_embarazo·", "periodos_de_embarazo")
  inflect.irregular("PeriodoDeEmbarazo", "Periodos·De·Embarazo·")
  inflect.irregular("Periodo·De·Embarazo·", "PeriodosDeEmbarazo")
  inflect.irregular("motivo_de_la_baja", "motivos·_de·_las·_bajas·")
  inflect.irregular("motivo·_de·_la·_baja·", "motivos_de_las_bajas")
  inflect.irregular("MotivoDeLaBaja", "Motivos·De·Las·Bajas·")
  inflect.irregular("Motivo·De·La·Baja·", "MotivosDeLasBajas")
  inflect.irregular("objeto_de_la_prestacion", "objetos·_de·_las·_prestaciones·")
  inflect.irregular("objeto·_de·_la·_prestacion·", "objetos_de_las_prestaciones")
  inflect.irregular("ObjetoDeLaPrestacion", "Objetos·De·Las·Prestaciones·")
  inflect.irregular("Objeto·De·La·Prestacion·", "ObjetosDeLasPrestaciones")
  inflect.irregular("convenio_de_gestion_sumar", "convenios·_de·_gestion·_sumar·")
  inflect.irregular("convenio·_de·_gestion·_sumar·", "convenios_de_gestion_sumar")
  inflect.irregular("ConvenioDeGestionSumar", "Convenios·De·Gestion·Sumar·")
  inflect.irregular("Convenio·De·Gestion·Sumar·", "ConveniosDeGestionSumar")
  inflect.irregular("convenio_de_administracion_sumar", "convenios·_de·_administracion·_sumar·")
  inflect.irregular("convenio·_de·_administracion·_sumar·", "convenios_de_administracion_sumar")
  inflect.irregular("ConvenioDeAdministracionSumar", "Convenios·De·Administracion·Sumar·")
  inflect.irregular("Convenio·De·Administracion·Sumar·", "ConveniosDeAdministracionSumar")
  inflect.irregular("metodo_de_validacion", "metodos·_de·_validacion·")
  inflect.irregular("metodo·_de·_validacion·", "metodos_de_validacion")
  inflect.irregular("MetodoDeValidacion", "Metodos·De·Validacion·")
  inflect.irregular("Metodo·De·Validacion·", "MetodosDeValidacion")
  inflect.irregular("dato_reportable_asociado", "datos·_reportables·_asociados·")
  inflect.irregular("dato·_reportable·_asociado·", "datos_reportables_asociados")
  inflect.irregular("DatoReportableAsociado", "Datos·Reportables·Asociados·")
  inflect.irregular("Dato·Reportable·Asociado·", "DatosReportablesAsociados")

  # Datos reportables requeridos
  inflect.irregular("dato_reportable_requerido", "datos·_reportables·_requeridos·")
  inflect.irregular("dato·_reportable·_requerido·", "datos_reportables_requeridos")
  inflect.irregular("DatoReportableRequerido", "Datos·Reportables·Requeridos·")
  inflect.irregular("Dato·Reportable·Requerido·", "DatosReportablesRequeridos")
  # Datos reportables requeridos - Corrección de mala pluralización irregular automática
  inflect.irregular("datos_reportables_requeridos", "datos·_reportables·_requeridos·")
  inflect.irregular("datos·_reportables·_requeridos·", "datos_reportables_requeridos")
  inflect.irregular("DatosReportablesRequeridos", "Datos·Reportables·Requeridos·")
  inflect.irregular("Datos·Reportables·Requeridos·", "DatosReportablesRequeridos")

  inflect.irregular("addenda_sumar", "addendas·_sumar·")
  inflect.irregular("addenda·_sumar·", "addendas_sumar")
  inflect.irregular("AddendaSumar", "Addendas·Sumar·")
  inflect.irregular("Addenda·Sumar·", "AddendasSumar")

  inflect.irregular("documentacion_respaldatoria", "documentaciones·_respaldatorias·")
  inflect.irregular("documentacion·_respaldatoria·", "documentaciones_respaldatorias")
  inflect.irregular("DocumentacionRespaldatoria", "Documentaciones·Respaldatorias·")
  inflect.irregular("Documentacion·Respaldatoria·", "DocumentacionesRespaldatorias")

  inflect.irregular("documentacion_respaldatoria_prestacion", "documentaciones·_respaldatorias·_prestaciones.")
  inflect.irregular("documentacion·_respaldatoria·_prestacion", "documentaciones_respaldatorias_prestaciones")
  inflect.irregular("DocumentacionRespaldatoriaPrestacion", "Documentaciones·Respaldatorias·Prestaciones.")
  inflect.irregular("Documentacion·Respaldatoria·Prestacion", "DocumentacionesRespaldatoriasPrestaciones")

  inflect.irregular("metodo_de_validacion_fallado", "metodos·_de·_validacion·_fallados·")
  inflect.irregular("metodo·_de·_validacion·_fallado·", "metodos_de_validacion_fallados")
  inflect.irregular("MetodoDeValidacionFallado", "Metodos·De·Validacion·Fallados·")
  inflect.irregular("Metodo·De·Validacion·Fallado·", "MetodosDeValidacionFallados")
  inflect.irregular("tipo_de_tratamiento", "tipos·_de·_tratamientos·")
  inflect.irregular("tipo·_de·_tratamiento·", "tipos_de_tratamientos")
  inflect.irregular("TipoDeTratamiento", "Tipos·De·Tratamientos·")
  inflect.irregular("Tipo·De·Tratamiento·", "TiposDeTratamientos")
  #Informes - Filtros
  inflect.irregular("informe_filtro", "informes·_filtros·")
  inflect.irregular("informe·_filtro·", "informes_filtros")
  inflect.irregular("InformeFiltro", "Informes·Filtros·")
  inflect.irregular("Informe·Filtro·", "InformesFiltros")
  #Informes - Filtros plural a plural
  #A veces trata de pluralizar cuando ya esta en plural, le agrego mas reglas
  inflect.irregular("informes_filtros", "informes·_filtros·")
  inflect.irregular("informes·_filtros·", "informes_filtros")
  inflect.irregular("InformesFiltros", "Informes·Filtros·")
  inflect.irregular("Informes·Filtros·", "InformesFiltros")
  #Conceptos de facturacion
  inflect.irregular("concepto_de_facturacion", "conceptos·_de·_facturacion·")
  inflect.irregular("concepto·_de·_facturacion·", "conceptos_de_facturacion")
  inflect.irregular("ConceptoDeFacturacion", "Conceptos·De·Facturacion·")
  inflect.irregular("Concepto·De·Facturacion·", "ConceptosDeFacturacion")
  #Liquidaciones Sumar
  inflect.irregular("liquidacion_sumar", "liquidaciones·_sumar·")
  inflect.irregular("liquidacion·_sumar·", "liquidaciones_sumar")
  inflect.irregular("LiquidacionSumar", "Liquidaciones·Sumar·")
  inflect.irregular("Liquidacion·Sumar·", "LiquidacionesSumar")
  #Grupo de efectores para liquidacion
  inflect.irregular("grupo_de_efectores_liquidacion", "grupos·_de·_efectores·_liquidaciones·")
  inflect.irregular("grupo·_de·_efectores·_liquidacion·", "grupo_de_efectores_liquidaciones")
  inflect.irregular("GrupoDeEfectoresLiquidacion", "Grupo·De·Efectores·Liquidaciones·")
  inflect.irregular("Grupo·De·Efectores·Liquidacion·", "GrupoDeEfectoresLiquidaciones")
  #Plantilla de Reglas
  inflect.irregular("plantilla_de_reglas", "plantillas·_de·_reglas·")
  inflect.irregular("plantilla·_de·_reglas·", "plantillas_de_reglas")
  inflect.irregular("PlantillaDeReglas", "Plantillas·De·Reglas·")
  inflect.irregular("Plantilla·De·Reglas·", "PlantillasDeReglas")
  #Liquidaciones Sumar
  inflect.irregular("liquidacion_sumar_cuasifactura", "liquidaciones·_sumar·_cuasifacturas·")
  inflect.irregular("liquidacion·_sumar·_cuasifactura·", "liquidaciones_sumar_cuasifacturas")
  inflect.irregular("LiquidacionSumarCuasifactura", "Liquidaciones·Sumar·Cuasifacturas·")
  inflect.irregular("Liquidacion·Sumar·Cuasifactura·", "LiquidacionesSumarCuasifacturas")
  # Liquidacion Sumar Cuasifactura detalle
  inflect.irregular("liquidacion_sumar_cuasifactura_detalle", "liquidaciones·_sumar·_cuasifacturas·_detalles·")
  inflect.irregular("liquidacion·_sumar·_cuasifactura·_detalle·", "liquidaciones_sumar_cuasifacturas_detalles")
  inflect.irregular("LiquidacionSumarCuasifacturaDetalle", "Liquidaciones·Sumar·Cuasifacturas·Detalles·")
  inflect.irregular("Liquidacion·Sumar·Cuasifactura·Detalle·", "LiquidacionesSumarCuasifacturasDetalles")
  # Estados de los procesos
  inflect.irregular("estado_del_proceso", "estados·_de·_los·_procesos·")
  inflect.irregular("estado·_del·_proceso·", "estados_de_los_procesos")
  inflect.irregular("EstadoDelProceso", "Estados·De·Los·Procesos·")
  inflect.irregular("Estado·Del·Proceso·", "EstadosDeLosProcesos")
  # Liquidacion Sumar Anexo Administrativo
  inflect.irregular("liquidacion_sumar_anexo_administrativo", "liquidaciones·_sumar·_anexos·_administrativos·")
  inflect.irregular("liquidacion·_sumar·_anexo·_administrativo·", "liquidaciones_sumar_anexos_administrativos")
  inflect.irregular("LiquidacionSumarAnexoAdministrativo", "Liquidaciones·Sumar·Anexos·Administrativos·")
  inflect.irregular("Liquidacion·Sumar·Anexo·Administrativo·", "LiquidacionesSumarAnexosAdministrativos")
  # Liquidacion Sumar Anexo Medico
  inflect.irregular("liquidacion_sumar_anexo_medico", "liquidaciones·_sumar·_anexos·_medicos·")
  inflect.irregular("liquidacion·_sumar·_anexo·_medico·", "liquidaciones_sumar_anexos_medicos")
  inflect.irregular("LiquidacionSumarAnexoMedico", "Liquidaciones·Sumar·Anexos·Medicos·")
  inflect.irregular("Liquidacion·Sumar·Anexo·Medico·", "LiquidacionesSumarAnexosMedicos")
  # Consolidado Sumar
  inflect.irregular("consolidado_sumar", "consolidados·_sumar·")
  inflect.irregular("consolidado·_sumar·", "consolidados_sumar")
  inflect.irregular("ConsolidadoSumar", "Consolidados·Sumar·")
  inflect.irregular("Consolidado·Sumar·", "ConsolidadosSumar")
  # Consolidado Sumar Detalle
  inflect.irregular("consolidado_sumar_detalle", "consolidados·_sumar·_detalles·")
  inflect.irregular("consolidado·_sumar·_detalle·", "consolidados_sumar_detalles")
  inflect.irregular("ConsolidadoSumarDetalle", "Consolidados·Sumar·Detalles·")
  inflect.irregular("Consolidado·Sumar·Detalle·", "ConsolidadosSumarDetalles")

  # UAD (unidad de alta de datos)
  inflect.irregular("uad_nombre", "uad·_nombres·")
  inflect.irregular("uad·_nombre·", "uad_nombre")
  inflect.irregular("UadNombre", "Uad·Nombres·")
  inflect.irregular("Uad·Nombre·", "UadNombres")

  #Informes - Uads
  inflect.irregular("informe_uad", "informes·_uads·")
  inflect.irregular("informe·_uad·", "informes_uads")
  inflect.irregular("InformeUad", "Informes·Uads·")
  inflect.irregular("Informe·Uad·", "InformesUads")

  #Vista global de prestaciones brindadas
  inflect.irregular("vista_global_de_prestacion_brindada", "vista·_global·_de·_prestaciones·_brindadas·")
  inflect.irregular("vista·_global·_de·_prestacion·_brindada·", "vista_global_de_prestaciones_brindadas")
  inflect.irregular("VistaGlobalDePrestacionBrindada", "Vista·Global·De·Prestaciones·Brindadas·")
  inflect.irregular("Vista·Global·De·Prestacion·Brindada·", "VistaGlobalDePrestacionesBrindadas")

  #Vista global de novedades de los afiliados
  inflect.irregular("vista_global_de_novedad_del_afiliado", "vista·_global·_de·_novedades·_de·_los·_afiliados·")
  inflect.irregular("vista·_global·_de·_novedad·_del·_afiliado·", "vista_global_de_novedades_de_los_afiliados")
  inflect.irregular("VistaGlobalDeNovedadDelAfiliado", "Vista·Global·De·Novedades·De·Los·Afiliados·")
  inflect.irregular("Vista·Global·De·Novedad·Del·Afiliado", "VistaGlobalDeNovedadesDeLosAfiliados")

  # Cantidad de prestaciones por periodo (tasas de uso)
  inflect.irregular("cantidad_de_prestaciones_por_periodo", "cantidades·_de·_prestaciones·_por·_periodo·")
  inflect.irregular("cantidad·_de·_prestaciones·_por·_periodo·", "cantidades_de_prestaciones_por_periodo")
  inflect.irregular("CantidadDePrestacionesPorPeriodo", "Cantidades·De·Prestaciones·Por·Periodo")
  inflect.irregular("Cantidad·De·Prestaciones·Por·Periodo", "CantidadesDePrestacionesPorPeriodo")

  # Cantidad de prestaciones por periodo (tasas de uso)
  inflect.irregular("cantidades_de_prestaciones_por_periodo", "cantidades·_de·_prestaciones·_por·_periodo·")
  inflect.irregular("cantidades·_de·_prestaciones·_por·_periodo·", "cantidades_de_prestaciones_por_periodo")
  inflect.irregular("CantidadesDePrestacionesPorPeriodo", "Cantidades·De·Prestaciones·Por·Periodo")
  inflect.irregular("Cantidades·De·Prestaciones·Por·Periodo", "CantidadesDePrestacionesPorPeriodo")

  
  # Expedientes Sumar
  inflect.irregular("expediente_sumar", "expedientes·_sumar·")
  inflect.irregular("expediente·_sumar·", "expedientes_sumar")
  inflect.irregular("ExpedienteSumar", "Expedientes·Sumar·")
  inflect.irregular("Expediente·Sumar·", "ExpedientesSumar")

  # Tipos de expedientes
  inflect.irregular("tipo_de_expediente", "tipos·_de·_expedientes·")
  inflect.irregular("tipo·_de·_expediente·", "tipos_de_expedientes")
  inflect.irregular("TipoDeExpediente", "Tipos·De·Expedientes·")
  inflect.irregular("Tipo·De·Expediente·", "TiposDeExpedientes")

  # Secciones del PDSS
  inflect.irregular("seccion_pdss", "secciones·_pdss·")
  inflect.irregular("seccion·_pdss·", "secciones_pdss")
  inflect.irregular("SeccionPdss", "Secciones·Pdss·")
  inflect.irregular("Seccion·Pdss·", "SeccionesPdss")

  # Grupos del PDSS
  inflect.irregular("grupo_pdss", "grupos·_pdss·")
  inflect.irregular("grupo·_pdss·", "grupos_pdss")
  inflect.irregular("GrupoPdss", "Grupos·Pdss·")
  inflect.irregular("Grupo·Pdss·", "GruposPdss")

#  # Apartados para subgrupos del PDSS
#  inflect.irregular("apartado_pdss", "apartados·_pdss·")
#  inflect.irregular("apartado·_pdss·", "apartados_pdss")
#  inflect.irregular("ApartadoPdss", "Apartados·Pdss·")
#  inflect.irregular("Apartado·Pdss·", "ApartadosPdss")

  # Prestaciones del PDSS
  inflect.irregular("prestacion_pdss", "prestaciones·_pdss·")
  inflect.irregular("prestacion·_pdss·", "prestaciones_pdss")
  inflect.irregular("PrestacionPdss", "Prestaciones·Pdss·")
  inflect.irregular("Prestacion·Pdss·", "PrestacionesPdss")

  # Prestaciones del PDSS
  inflect.irregular("prestaciones_pdss", "prestaciones·_pdss·")
  inflect.irregular("prestaciones·_pdss·", "prestaciones_pdss")
  inflect.irregular("PrestacionesPdss", "Prestaciones·Pdss·")
  inflect.irregular("Prestaciones·Pdss·", "PrestacionesPdss")

  # Prestaciones Prestaciones del PDSS
  inflect.irregular("prestacion_prestacion_pdss", "prestaciones·_prestaciones·_pdss·")
  inflect.irregular("prestacion·_prestacion·_pdss·", "prestaciones_prestaciones_pdss")
  inflect.irregular("PrestacionPrestacionPdss", "Prestaciones·Prestaciones·Pdss·")
  inflect.irregular("Prestacion·Prestacion·Pdss·", "PrestacionesPrestacionesPdss")

  # Corrección de mala pluralización irregular automática
  inflect.irregular("prestaciones_prestaciones_pdss", "prestaciones·_prestaciones·_pdss·")
  inflect.irregular("prestaciones·_prestaciones·_pdss·", "prestaciones_prestaciones_pdss")
  inflect.irregular("PrestacionesPrestacionesPdss", "Prestaciones·Prestaciones·Pdss·")
  inflect.irregular("Prestaciones·Prestaciones·Pdss·", "PrestacionesPrestacionesPdss")

  # Prestaciones PDSS autorizadas por efector
  inflect.irregular("prestacion_pdss_autorizada", "prestaciones·_pdss·_autorizadas·")
  inflect.irregular("prestacion·_pdss·_autorizada·", "prestaciones_pdss_autorizadas")
  inflect.irregular("PrestacionPdssAutorizada", "Prestaciones·Pdss·Autorizadas·")
  inflect.irregular("Prestacion·Pdss·Autorizada·", "PrestacionesPdssAutorizadas")

  #Detalles de debitos prestacionales
  inflect.irregular("detalle_de_debito_prestacional", "detalles·_de·_debitos·_prestacionales·")
  inflect.irregular("detalle·_de·_debito·_prestacional·", "detalles_de_debitos_prestacionales")
  inflect.irregular("DetalleDeDebitoPrestacional", "Detalles·De·Debitos·Prestacionales·")
  inflect.irregular("Detalle·De·Debito·Prestacional·", "DetallesDeDebitosPrestacionales")

  #  modulo de Delayed_job
  inflect.irregular("tipo_proceso_de_sistema", "tipos·_procesos·_de·_sistemas·")
  inflect.irregular("tipos·_procesos·_des·_sistemas·", "tipos_procesos_de_sistemas")

  inflect.irregular("estado_proceso_de_sistema", "estados·_procesos·_de·_sistemas·")
  inflect.irregular("estados·_procesos·_de·_sistemas·", "estados_procesos_de_sistemas")

  inflect.irregular("proceso_de_sistema", "procesos·_de·_sistemas·")
  inflect.irregular("procesos·_de·_sistemas·", "procesos_de_sistemas")
  inflect.irregular("job","jobs")


  #Codigos de gastos
  inflect.irregular("subcodigo_de_gasto", "subcodigos·_de·_gastos·")
  inflect.irregular("subcodigos·_de·_gastos·", "subcodigos_de_gastos")
  #Tipo de debito prestacional
  inflect.irregular("tipo_de_debito_prestacional", "tipos·_de·_debitos·_prestacionales·")
  inflect.irregular("tipo·_de·_debito·_prestacional·", "tipos_de_debitos_prestacionales")
  inflect.irregular("TipoDeDebitoPrestacional", "Tipos·De·Debitos·Prestacionales·")
  inflect.irregular("Tipo·De·Debito·Prestacional·", "TiposDeDebitosPrestacionales")

  #Informes debitos prestacionales
  inflect.irregular("informe_debito_prestacional", "informes·_debitos·_prestacionales·")
  inflect.irregular("informe·_debito·_prestacional·", "informes_debitos_prestacionales")
  inflect.irregular("InformeDebitoPrestacionales", "Informes·Debitos·Prestacionales·")
  inflect.irregular("Informe·Debito·Prestacionales·", "InformesDebitosPrestacionales")

  # Tipos De notas De Debito
  inflect.irregular("tipo_de_nota_debito", "tipos·_de·_notas·_debito·")
  inflect.irregular("tipo·_de·_nota·_debito·", "tipos_de_notas_debito")
  inflect.irregular("TipoDeNotaDebito", "Tipos·De·Notas·Debito·")
  inflect.irregular("Tipo·De·Nota·Debito·", "TiposDeNotasDebito")

  # Notas de debito
  inflect.irregular("nota_de_debito", "notas·_de·_debito·")
  inflect.irregular("nota·_de·_debito·", "notas_de_debito")
  inflect.irregular("NotaDeDebito", "Notas·De·Debito·")
  inflect.irregular("Nota·De·Debito·", "NotasDeDebito")

  # Documentos Generables
  inflect.irregular("documento_generable", "documentos·_generables·")
  inflect.irregular("documento·_generable·", "documentos_generables")
  inflect.irregular("DocumentoGenerable", "Documentos·Generables·")
  inflect.irregular("Documento·Generable·", "DocumentosGenerables")

  # Documentos Generables Por Concepto
  inflect.irregular("documento_generable_por_concepto", "documentos·_generables·_por·_conceptos·")
  inflect.irregular("documento·_generable·_por·_concepto·", "documentos_generables_por_conceptos")
  inflect.irregular("DocumentoGenerablePorConcepto", "Documentos·Generables·Por·Conceptos·")
  inflect.irregular("Documento·Generable·Por·Concepto·", "DocumentosGenerablesPorConceptos")

  # Tipos de agrupacion
  inflect.irregular("tipo_de_agrupacion", "tipos·_de·_agrupacion·")
  inflect.irregular("tipo·_de·_agrupacion·", "tipos_de_agrupacion")
  inflect.irregular("TipoDeAgrupacion", "Tipos·De·Agrupacion·")
  inflect.irregular("Tipo·De·Agrupacion·", "TiposDeAgrupacion")

  # Partos SIP
  inflect.irregular("parto_sip", "partos·_sip·")
  inflect.irregular("parto·_sip·", "partos_sip")
  inflect.irregular("PartoSip", "Partos·Sip·")
  inflect.irregular("Parto·Sip·", "PartosSip")

  # Líneas de cuidado
  inflect.irregular("linea_de_cuidado", "lineas·_de·_cuidado·")
  inflect.irregular("linea·_de·_cuidado·", "lineas_de_cuidado")
  inflect.irregular("LineaDeCuidado", "Lineas·De·Cuidado·")
  inflect.irregular("Linea·De·Cuidado·", "LineasDeCuidado")

  # Grupos de diagnósticos
  inflect.irregular("grupo_de_diagnosticos", "grupos·_de·_diagnosticos·")
  inflect.irregular("grupo·_de·_diagnosticos·", "grupos_de_diagnosticos")
  inflect.irregular("GrupoDeDiagnosticos", "Grupos·De·Diagnosticos·")
  inflect.irregular("Grupo·De·Diagnosticos·", "GruposDeDiagnosticos")

  # Resultados de otoemisiones
  inflect.irregular("resultado_de_otoemision", "resultados·_de·_otoemisiones·")
  inflect.irregular("resultado·_de·_otoemision·", "resultados_de_otoemisiones")
  inflect.irregular("ResultadoDeOtoemision", "Resultados·De·Otoemisiones·")
  inflect.irregular("Resultado·De·Otoemision·", "ResultadosDeOtoemisiones")

  # Resultados VDRL
  inflect.irregular("resultado_vdrl", "resultados·_vdrl·")
  inflect.irregular("resultado·_vdrl·", "resultados_vdrl")
  inflect.irregular("ResultadoVdrl", "Resultados·Vdrl·")
  inflect.irregular("Resultado·Vdrl·", "ResultadosVdrl")

  # Tratamientos instaurados (CA de cuello)
  inflect.irregular("tratamiento_instaurado_cu", "tratamientos·_instaurados·_cu·")
  inflect.irregular("tratamiento·_instaurado·_cu·", "tratamientos_instaurdados_cu")
  inflect.irregular("TratamientoInstauradoCu", "Tratamientos·Instaurados·Cu·")
  inflect.irregular("Tratamiento·Instaurado·Cu·", "TratamientosInstauradosCu")

  # Datos reportables definidos por el SIRGE
  inflect.irregular("dato_reportable_sirge", "datos·_reportables·_sirge·")
  inflect.irregular("dato·_reportable·_sirge·", "datos_reportables_sirge")
  inflect.irregular("DatoReportableSirge", "Datos·Reportables·Sirge·")
  inflect.irregular("Dato·Reportable·Sirge·", "DatosReportablesSirge")

  # Datos reportables requeridos por el SIRGE (por prestación)
  inflect.irregular("dato_reportable_requerido_sirge", "datos·_reportables·_requeridos·_sirge·")
  inflect.irregular("dato·_reportable·_requerido·_sirge·", "datos_reportables_requeridos_sirge")
  inflect.irregular("DatoReportableRequeridoSirge", "Datos·Reportables·Requeridos·Sirge·")
  inflect.irregular("Dato·Reportable·Requerido·Sirge·", "DatosReportablesRequeridosSirge")

  # Plurales para verbos y otros
  inflect.irregular("prohíbe", "prohíben·")
  inflect.irregular("prohíbe·", "prohíben")
  inflect.irregular("impide", "impiden·")
  inflect.irregular("impide·", "impiden")
  inflect.irregular("informe", "informes·")
  inflect.irregular("informe·", "informes")
  inflect.irregular("Informe", "Informes·")
  inflect.irregular("mes", "meses")
  inflect.irregular("meses·", "meses")
  inflect.irregular("año", "años")
  inflect.irregular("años", "años")
  inflect.irregular("semana", "semanas")
  inflect.irregular("semanas", "semanas")
  
  # Plurales para solicitudes de addenda
  inflect.irregular("solicitud_addenda","solicitudes·_addendas·")
  inflect.irregular("estado_solicitud_addenda","estados·_solicitudes·_addendas·")
  inflect.irregular("solicitud_addenda_prestacion_principal","solicitudes·_addendas·_prestaciones·_principales·")

  # Plurales para los informes de rendicion y gastos
  inflect.irregular("informe_de_rendicion", "informes·_de·_rendicion·")
  inflect.irregular("informes·_de·_rendicion·", "informes_de_rendicion")
  inflect.irregular("InformeDeRendicion", "Informes·De·Rendicion·")
  inflect.irregular("Informes·De·Rendicion·", "InformesDeRendicion")
  
  inflect.irregular("detalle_informe_de_rendicion", "detalles·_informe·_de·_rendicion·")
  inflect.irregular("detalles·_informe·_de·_rendicion·", "detalles_informe_de_rendicion")
  inflect.irregular("DetalleInformeDeRendicion", "Detalles·Informe·De·Rendicion·")
  inflect.irregular("Detalles·Informe·De·Rendicion·", "DetallesInformeDeRendicion")

  inflect.irregular("tipo_de_importe", "tipos·_de·_importe·")
  inflect.irregular("tipos·_de·_importe·", "tipos_de_importe")
  inflect.irregular("TipoDeImporte", "Tipos·De·Importe·")
  inflect.irregular("Tipos·De·Importe·", "TiposDeImporte")

  inflect.irregular("clase_de_gasto", "clases·_de·_gasto·")
  inflect.irregular("clases·_de·_gasto·", "clases_de_gasto")
  inflect.irregular("ClaseDeGasto", "Clases·De·Gasto·")
  inflect.irregular("Clases·De·Gasto·", "ClasesDeGasto")

  inflect.irregular("tipo_de_gasto", "tipos·_de·_gasto·")
  inflect.irregular("tipos·_de·_gasto·", "tipos_de_gasto")
  inflect.irregular("TipoDeGasto", "Tipos·De·Gasto·")
  inflect.irregular("Tipos·De·Gasto·", "TiposDeGasto")

  # Humanización de cadenas
  inflect.human("provincia_bio_id", "código identificador de provincia (Bioestadística)")
  inflect.human("departamento_bio_id", "código identificador de departamento (Bioestadística)")
  inflect.human("departamento_indec_id", "código identificador de departamento (INDEC)")
  inflect.human("departamento_insc_id", "código identificador de departamento (Inscripción)")
  inflect.human("codigo_postal", "código postal")
  inflect.human("distrito_bio_id", "código identificador de distrito (Bioestadística)")
  inflect.human("distrito_insc_id", "código identificador de distrito (Inscripción)")
  inflect.human("distrito_indec_id", "código identificador de distrito (INDEC)")
  inflect.human("alias_id", "Alias del identificador de distrito")
  inflect.human("user_group_name", "nombre del grupo de usuarios")
  inflect.human("firstname", "nombre")
  inflect.human("lastname", "apellido")
  inflect.human("login", "nombre de usuario del sistema")
  inflect.human("email", "dirección de correo electrónico")
  inflect.human("password", "contraseña")
  inflect.human("password_confirmation", "confirmación de contraseña")
  inflect.human("user", "usuario")
  inflect.human("user_id", "usuario")
  inflect.human("group", "grupo")
  inflect.human("group_id", "grupo")
  inflect.human("user_group", "grupo de usuarios")
  inflect.human("mostrado", "nombre mostrado")
  inflect.human("dni", "número de documento")
  inflect.human("email_adicional", "dirección de correo electrónico adicional")
  inflect.human("telefono", "teléfono fijo")
  inflect.human("telefono_movil", "teléfono celular")
  inflect.human("email_notificacion", "e-mails para notificación (separar con comas)")
  inflect.human("fecha_de_suscripcion", "fecha de suscripción")
  inflect.human("fecha_de_finalizacion", "fecha de finalización")
  inflect.human("grupo_bio_id", "código identificador de grupo (Bioestadística)")
  inflect.human("convenio_de_gestion", "convenio de gestión")
  inflect.human("convenio_de_gestion_id", "convenio de gestión")
  inflect.human("convenio_de_administracion", "convenio de administración")
  inflect.human("convenio_de_administracion_id", "convenio de administración")
  inflect.human("cuie", "CUIE")
  inflect.human("codigo_de_efector_sissa", "código SISA")
  inflect.human("codigo_de_efector_bio", "código para bioestadística")
  inflect.human("telefonos", "teléfonos")
#  inflect.human("grupo_de_efectores_id", "grupo de efectores")
  inflect.human("area_de_prestacion_id", "área de prestación")
  inflect.human("alto_impacto", "efector de alto impacto")
  inflect.human("camas_de_internacion", "camas de internación")
#  inflect.human("dependencia_administrativa_id", "dependencia administrativa")
  inflect.human("evaluacion_de_impacto", "evaluación de impacto")
#  inflect.human("tipo_de_dependencia_id", "tipo de dependencia")
#  inflect.human("contacto_id", "contacto")
#  inflect.human("grupo_de_prestaciones_id", "grupo de prestaciones")
#  inflect.human("subgrupo_de_prestaciones_id", "subgrupo de prestaciones")
  inflect.human("codigo", "código")
#  inflect.human("unidad_de_medida_id", "unidad de medida")
  inflect.human("prestacion_id", "prestación")
  inflect.human("adicional_por_prestacion", "adicional por prestación")
  inflect.human("unidades_maximas", "unidades máximas")
#  inflect.human("nomenclador_id", "nomenclador")
  inflect.human("titulo", "título")
  inflect.human("numero", "número")
  inflect.human("descripcion", "descripción")
  inflect.human("current_password", "contraseña actual")

  # Novedades de los afiliados
  inflect.human("numero_de_documento", "número de documento")
  inflect.human("numero_de_celular", "número de celular")
  inflect.human("e_mail", "dirección de correo electrónico")
  inflect.human("pais_de_nacimiento_id", "país de nacimiento")
  inflect.human("se_declara_indigena", "se declara indígena")
  inflect.human("alfabetizacion_del_beneficiario_id", "alfabetización")
  inflect.human("alfab_beneficiario_anios_ultimo_nivel", "años cursados en el mayor nivel")
  inflect.human("domicilio_calle", "calle")
  inflect.human("domicilio_numero", "número de puerta o casa")
  inflect.human("domicilio_piso", "piso")
  inflect.human("domicilio_depto", "departamento (del piso indicado)")
  inflect.human("domicilio_manzana", "manzana")
  inflect.human("domicilio_entre_calle_1", "entre calle")
  inflect.human("domicilio_entre_calle_2", "y calle")
  inflect.human("otro_telefono", "otro teléfono (vecino, pariente, etc.)")
  inflect.human("domicilio_departamento_id", "Departamento")
  inflect.human("domicilio_distrito_id", "Distrito")
  inflect.human("domicilio_barrio_o_paraje", "Barrio o paraje")
  inflect.human("domicilio_codigo_postal", "código postal")
  inflect.human("lugar_de_atencion_habitual_id", "lugar de atención habitual")
  inflect.human("apellido_de_la_madre", "apellido")
  inflect.human("nombre_de_la_madre", "nombre")
  inflect.human("tipo_de_documento_de_la_madre_id", "tipo de documento")
  inflect.human("numero_de_documento_de_la_madre", "número de documento de la madre")
  inflect.human("alfabetizacion_de_la_madre_id", "alfabetización")
  inflect.human("alfab_madre_anios_ultimo_nivel", "años cursados en el mayor nivel")
  inflect.human("apellido_del_padre", "apellido")
  inflect.human("nombre_del_padre", "nombre")
  inflect.human("tipo_de_documento_del_padre_id", "tipo de documento")
  inflect.human("numero_de_documento_del_padre", "número de documento del padre")
  inflect.human("alfabetizacion_del_padre_id", "alfabetización")
  inflect.human("alfab_padre_anios_ultimo_nivel", "años cursados en el mayor nivel")
  inflect.human("apellido_del_tutor", "apellido")
  inflect.human("nombre_del_tutor", "nombre")
  inflect.human("tipo_de_documento_del_tutor_id", "tipo de documento")
  inflect.human("numero_de_documento_del_tutor", "número de documento del tutor/a")
  inflect.human("alfabetizacion_del_tutor_id", "alfabetización")
  inflect.human("alfab_tutor_anios_ultimo_nivel", "años cursados en el mayor nivel")
  inflect.human("esta_embarazada", "cursa embarazo o puerperio")
  inflect.human("fecha_de_la_ultima_menstruacion", "fecha de la última menstruación")
  inflect.human("fecha_de_diagnostico_del_embarazo", "fecha de diagnóstico del embarazo")
  inflect.human("semanas_de_embarazo", "semanas de embarazo al diagnóstico")
  inflect.human("score_de_riesgo", "score de riesgo cardiovascular")
  inflect.human("fecha_de_la_novedad", "fecha de inscripción/modificación")
  inflect.human("centro_de_inscripcion_id", "centro de inscripción")
  inflect.irregular("motivo_baja_beneficiario","motivos·_bajas·_beneficiarios·")

  #Tablas de configuracion
  #Paises
  inflect.human("pais_bio_id", "Id de Bioestadística")

  #

end
