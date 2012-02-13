# Cpnfiguración de las características de FTS para búsquedas
load 'db/configuracion_fts.rb'

# Datos iniciales para los modelos de georreferenciación

load 'db/Provincias_seed.rb'
load 'db/Departamentos_seed.rb'
load 'db/Distritos_seed.rb'

# Sexo masculino/femenino
load 'db/Sexos_seed.rb'

# Datos iniciales para usuarios y grupos
load 'db/UserGroups_seed.rb'
load 'db/Users_seed.rb'

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
