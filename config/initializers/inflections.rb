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

  # Plurales para verbos y otros
  inflect.irregular("prohíbe", "prohíben·")
  inflect.irregular("prohíbe·", "prohíben")
  inflect.irregular("impide", "impiden·")
  inflect.irregular("impide·", "impiden")

  # Humanización de cadenas
  inflect.human("provincia_bio_id", "código identificador de provincia (Bioestadística)")
#  inflect.human("provincia_id", "provincia")
  inflect.human("departamento_bio_id", "código identificador de departamento (Bioestadística)")
  inflect.human("departamento_indec_id", "código identificador de departamento (INDEC)")
  inflect.human("departamento_insc_id", "código identificador de departamento (Inscripción)")
#  inflect.human("departamento_id", "departamento")
  inflect.human("codigo_postal", "código postal")
  inflect.human("distrito_bio_id", "código identificador de distrito (Bioestadística)")
  inflect.human("distrito_insc_id", "código identificador de distrito (Inscripción)")
  inflect.human("distrito_indec_id", "código identificador de distrito (INDEC)")
  inflect.human("alias_id", "Alias del identificador de distrito")
  inflect.human("user_group_name", "nombre del grupo de usuarios")
  inflect.human("firstname", "nombre")
  inflect.human("lastname", "apellido")
  inflect.human("login", "nombre de usuario del sistema")
  inflect.human("email", "e-mail")
  inflect.human("password", "contraseña")
  inflect.human("password_confirmation", "confirmación de contraseña")
  inflect.human("user", "usuario")
  inflect.human("user_id", "usuario")
  inflect.human("group", "grupo")
  inflect.human("group_id", "grupo")
  inflect.human("user_group", "grupo de usuarios")
  inflect.human("mostrado", "texto mostrado")
  inflect.human("dni", "Documento nacional de identidad")
  inflect.human("email_adicional", "e-mail adicional")
  inflect.human("telefono", "teléfono")
  inflect.human("telefono_movil", "teléfono celular")
#  inflect.human("efector_id", "efector")
  inflect.human("email_notificacion", "e-mails para notificación (separar con comas)")
#  inflect.human("administrador_id", "administrador")
  inflect.human("fecha_de_suscripcion", "fecha de suscripción")
  inflect.human("fecha_de_finalizacion", "fecha de finalización")
  inflect.human("grupo_bio_id", "código identificador de grupo (Bioestadística)")
  inflect.human("convenio_de_gestion", "convenio de gestión")
  inflect.human("convenio_de_gestion_id", "convenio de gestión")
  inflect.human("convenio_de_administracion", "convenio de administración")
  inflect.human("convenio_de_administracion_id", "convenio de administración")
  inflect.human("cuie", "CUIE")
  inflect.human("efector_sissa_id", "código identificador del efector (SISSA)")
  inflect.human("efector_bio_id", "código identificador del efector (Bioestadística)")
#  inflect.human("distrito_id", "distrito")
  inflect.human("telefonos", "teléfonos")
#  inflect.human("grupo_de_efectores_id", "grupo de efectores")
  inflect.human("area_de_prestacion_id", "área de prestación")
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

  # Novedades de los afiliados
  inflect.human("numero_de_documento", "número de documento")
  inflect.human("numero_de_celular", "número de celular")
  inflect.human("e_mail", "dirección de correo electrónico")
  inflect.human("pais_de_nacimiento_id", "país de nacimiento")
  inflect.human("se_declara_indigena", "se declara indígena")
  inflect.human("alfabetizacion_del_beneficiario_id", "alfabetización")
  inflect.human("alfab_beneficiario_años_ultimo_nivel", "años cursados en el mayor nivel")
  inflect.human("domicilio_calle", "calle")
  inflect.human("domicilio_numero", "número de puerta / casa")
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
  inflect.human("numero_de_documento_de_la_madre", "número de documento (madre)")
  inflect.human("alfabetizacion_de_la_madre_id", "alfabetización")
  inflect.human("alfab_madre_años_ultimo_nivel", "años cursados en el mayor nivel")
  inflect.human("apellido_del_padre", "apellido")
  inflect.human("nombre_del_padre", "nombre")
  inflect.human("tipo_de_documento_del_padre_id", "tipo de documento")
  inflect.human("numero_de_documento_del_padre", "número de documento (padre)")
  inflect.human("alfabetizacion_del_padre_id", "alfabetización")
  inflect.human("alfab_padre_años_ultimo_nivel", "años cursados en el mayor nivel")
  inflect.human("apellido_del_tutor", "apellido")
  inflect.human("nombre_del_tutor", "nombre")
  inflect.human("tipo_de_documento_del_tutor_id", "tipo de documento")
  inflect.human("numero_de_documento_del_tutor", "número de documento (tutor)")
  inflect.human("alfabetizacion_del_tutor_id", "alfabetización")
  inflect.human("alfab_tutor_años_ultimo_nivel", "años cursados en el mayor nivel")
  inflect.human("esta_embarazada", "está embarazada")
  inflect.human("fecha_de_la_ultima_menstruacion", "fecha de la última menstruación")
  inflect.human("fecha_de_diagnostico_del_embarazo", "fecha de diagnóstico del embarazo")
  inflect.human("score_de_riesgo", "score de riesgo cardiovascular")
  inflect.human("fecha_de_la_novedad", "fecha de inscripción/modificación")
  inflect.human("centro_de_inscripcion_id", "centro de inscripción")

end
