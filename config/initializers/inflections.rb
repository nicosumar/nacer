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

  # Plurales para verbos y otros
  inflect.irregular("prohíbe", "prohíben·")
  inflect.irregular("prohíbe·", "prohíben")
  inflect.irregular("impide", "impiden·")
  inflect.irregular("impide·", "impiden")
  inflect.irregular("al", "a· los·")
  inflect.irregular("al·", "a los")

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
  inflect.human("dni", "DNI")
  inflect.human("email_adicional", "e-mail adicional")
  inflect.human("telefono", "teléfono")
  inflect.human("telefono_movil", "celular (teléfono móvil)")
#  inflect.human("efector_id", "efector")
  inflect.human("email_notificacion", "e-mail para notificación")
#  inflect.human("administrador_id", "administrador")
  inflect.human("fecha_de_suscripcion", "fecha de suscripción")
  inflect.human("fecha_de_finalizacion", "fecha de finalización")
  inflect.human("grupo_bio_id", "código identificador de grupo (Bioestadística)")
  inflect.human("convenio_de_gestion", "convenio de gestión")
  inflect.human("convenio_de_gestion_id", "convenio de gestión")
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

end
