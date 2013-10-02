# -*- encoding : utf-8 -*-
# Cpnfiguración de las características de FTS para búsquedas
load 'db/configuracion_fts.rb'

# Datos iniciales para los modelos de georreferenciación

load 'db/Provincias_seed.rb'
load 'db/Departamentos_seed.rb'
load 'db/Distritos_seed.rb'

# Sexo masculino/femenino
load 'db/Sexos_seed.rb'

# Datos iniciales para usuarios y grupos
load 'db/Users_seed.rb'
load 'db/UserGroups_seed.rb'
load 'db/UserGroupsUsers_seed.rb'

# Datos iniciales para el módulo de convenios
load 'db/AreasDePrestacion_seed.rb'
load 'db/GruposDeEfectores_seed.rb'
load 'db/DependenciasAdministrativas_seed.rb'
load 'db/Contactos_seed.rb'
load 'db/Efectores_seed.rb'
load 'db/ConveniosDeAdministracion_seed.rb'
load 'db/ConveniosDeGestion_seed.rb'
load 'db/Addendas_seed.rb'
load 'db/Referentes_seed.rb'

# Datos iniciales para el módulo de nomencladores
load 'db/GruposDePrestaciones_seed.rb'
load 'db/SubgruposDePrestaciones_seed.rb'
load 'db/UnidadesDeMedida_seed.rb'
load 'db/Prestaciones_seed.rb'
load 'db/PrestacionesAutorizadas_seed.rb'
load 'db/Nomencladores_seed.rb'
load 'db/AsignacionesDePrecios_seed.rb'
load 'db/AsignacionesDeNomenclador_seed.rb'

# Afiliados
load 'db/CategoriasDeAfiliados_seed.rb'
load 'db/Afiliados_seed.rb'

# Datos iniciales para el módulo de inscripciones
load 'db/TiposDeNovedades_seed.rb'
load 'db/CentrosDeInscripcion_seed.rb'
load 'db/EstadosDeLasNovedades_seed.rb'
load 'db/LenguasOriginarias_seed.rb'
load 'db/TribusOriginarias_seed.rb'
load 'db/TiposDeRelaciones_seed.rb'
load 'db/NivelesDeInstruccion_seed.rb'
load 'db/Discapacidades_seed.rb'
load 'db/NovedadesDeLosAfiliados_seed.rb'

# Datos iniciales para la CEB
load 'db/GruposPoblacionales_seed.rb'

# Datos iniciales para el módulo de facturación
load 'db/TiposDePrestaciones_seed.rb'
load 'db/Diagnosticos_seed.rb'
load 'db/ObjetosDeLasPrestaciones_seed.rb'
load 'db/PrestacionesBrindadas_seed.rb'
load 'db/ConveniosDeGestionSumar_seed.rb'
load 'db/ConveniosDeAdministracionSumar_seed.rb'
load 'db/MetodosDeValidacion_seed.rb'
load 'db/DatosReportables_seed.rb'
load 'db/PrestacionesSumar_seed.rb'
load 'db/PrestacionesSumarFaltantes_seed.rb'
load 'db/TiposDeTratamientos_seed.rb'

# Datos iniciales para el módulo de liquidaciones
load 'db/ConceptosDeFacturacion_seed.rb'
load 'db/ReglasPredeterminadas_seed.rb'

# Datos para documentacion respaldatoria 
load 'db/DocumentacionesRespaldatorias_seed.rb'