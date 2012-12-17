# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121217121733) do

  create_table "addendas", :force => true do |t|
    t.integer  "convenio_de_gestion_id", :null => false
    t.string   "firmante"
    t.date     "fecha_de_suscripcion"
    t.date     "fecha_de_inicio",        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "observaciones"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.string   "numero"
  end

  add_index "addendas", ["numero"], :name => "unq_addendas_numero", :unique => true

  create_table "afiliados", :id => false, :force => true do |t|
    t.integer "afiliado_id",                           :null => false
    t.string  "clave_de_beneficiario",                 :null => false
    t.string  "apellido"
    t.string  "nombre"
    t.integer "clase_de_documento_id"
    t.integer "tipo_de_documento_id"
    t.string  "numero_de_documento"
    t.string  "numero_de_celular"
    t.string  "e_mail"
    t.integer "categoria_de_afiliado_id"
    t.integer "sexo_id"
    t.date    "fecha_de_nacimiento"
    t.integer "pais_de_nacimiento_id"
    t.boolean "se_declara_indigena"
    t.integer "lengua_originaria_id"
    t.integer "tribu_originaria_id"
    t.integer "alfabetizacion_del_beneficiario_id"
    t.integer "alfab_beneficiario_anios_ultimo_nivel"
    t.string  "domicilio_calle"
    t.string  "domicilio_numero"
    t.string  "domicilio_piso"
    t.string  "domicilio_depto"
    t.string  "domicilio_manzana"
    t.string  "domicilio_entre_calle_1"
    t.string  "domicilio_entre_calle_2"
    t.string  "telefono"
    t.string  "otro_telefono"
    t.integer "domicilio_departamento_id"
    t.integer "domicilio_distrito_id"
    t.string  "domicilio_barrio_o_paraje"
    t.string  "domicilio_codigo_postal"
    t.integer "lugar_de_atencion_habitual_id"
    t.string  "apellido_de_la_madre"
    t.string  "nombre_de_la_madre"
    t.integer "tipo_de_documento_de_la_madre_id"
    t.string  "numero_de_documento_de_la_madre"
    t.integer "alfabetizacion_de_la_madre_id"
    t.integer "alfab_madre_anios_ultimo_nivel"
    t.string  "apellido_del_padre"
    t.string  "nombre_del_padre"
    t.integer "tipo_de_documento_del_padre_id"
    t.string  "numero_de_documento_del_padre"
    t.integer "alfabetizacion_del_padre_id"
    t.integer "alfab_padre_anios_ultimo_nivel"
    t.string  "apellido_del_tutor"
    t.string  "nombre_del_tutor"
    t.integer "tipo_de_documento_del_tutor_id"
    t.string  "numero_de_documento_del_tutor"
    t.integer "alfabetizacion_del_tutor_id"
    t.integer "alfab_tutor_anios_ultimo_nivel"
    t.boolean "embarazo_actual"
    t.date    "fecha_de_la_ultima_menstruacion"
    t.date    "fecha_de_diagnostico_del_embarazo"
    t.integer "semanas_de_embarazo"
    t.date    "fecha_probable_de_parto"
    t.date    "fecha_efectiva_de_parto"
    t.integer "score_de_riesgo"
    t.integer "discapacidad_id"
    t.date    "fecha_de_inscripcion"
    t.date    "fecha_de_la_ultima_novedad"
    t.integer "unidad_de_alta_de_datos_id"
    t.integer "centro_de_inscripcion_id"
    t.text    "observaciones_generales"
    t.boolean "activo"
    t.integer "motivo_de_la_baja_id"
    t.string  "mensaje_de_la_baja"
    t.date    "fecha_de_carga"
    t.string  "usuario_que_carga"
  end

  add_index "afiliados", ["afiliado_id"], :name => "index_afiliados_on_afiliado_id", :unique => true
  add_index "afiliados", ["clave_de_beneficiario"], :name => "index_afiliados_on_clave_de_beneficiario", :unique => true

  create_table "areas_de_prestacion", :force => true do |t|
    t.string "nombre"
  end

  create_table "asignaciones_de_nomenclador", :force => true do |t|
    t.integer  "efector_id",            :null => false
    t.integer  "nomenclador_id",        :null => false
    t.date     "fecha_de_inicio",       :null => false
    t.date     "fecha_de_finalizacion"
    t.text     "observaciones"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "asignaciones_de_precios", :force => true do |t|
    t.integer  "nomenclador_id",                                                           :null => false
    t.integer  "prestacion_id",                                                            :null => false
    t.decimal  "precio_por_unidad",        :precision => 15, :scale => 4,                  :null => false
    t.decimal  "adicional_por_prestacion", :precision => 15, :scale => 4, :default => 0.0
    t.integer  "unidades_maximas"
    t.text     "observaciones"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "busquedas", :force => true do |t|
    t.integer  "modelo_id",   :null => false
    t.string   "modelo_type", :null => false
    t.string   "titulo",      :null => false
    t.text     "texto",       :null => false
    t.tsvector "vector_fts",  :null => false
  end

  add_index "busquedas", ["modelo_type", "modelo_id"], :name => "idx_unq_modelo", :unique => true
  add_index "busquedas", ["vector_fts"], :name => "idx_gin_on_vector_fts"

  create_table "categorias_de_afiliados", :force => true do |t|
    t.string "nombre", :null => false
    t.string "codigo", :null => false
  end

  create_table "categorias_de_afiliados_prestaciones", :id => false, :force => true do |t|
    t.integer "categoria_de_afiliado_id"
    t.integer "prestacion_id"
  end

  create_table "centros_de_inscripcion", :force => true do |t|
    t.string   "nombre",     :null => false
    t.string   "codigo",     :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "creator_id"
    t.integer  "updater_id"
  end

  create_table "centros_de_inscripcion_unidades_de_alta_de_datos", :id => false, :force => true do |t|
    t.integer "centro_de_inscripcion_id",   :null => false
    t.integer "unidad_de_alta_de_datos_id", :null => false
  end

  create_table "clases_de_documentos", :force => true do |t|
    t.string "nombre"
    t.string "codigo"
  end

  create_table "contactos", :force => true do |t|
    t.string   "nombres"
    t.string   "apellidos"
    t.string   "mostrado",        :null => false
    t.string   "dni"
    t.text     "domicilio"
    t.string   "email"
    t.string   "email_adicional"
    t.string   "telefono"
    t.string   "telefono_movil"
    t.text     "observaciones"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sexo_id"
    t.integer  "creator_id"
    t.integer  "updater_id"
  end

  create_table "convenios_de_administracion", :force => true do |t|
    t.string   "numero",                :null => false
    t.integer  "administrador_id",      :null => false
    t.integer  "efector_id",            :null => false
    t.string   "firmante"
    t.date     "fecha_de_suscripcion"
    t.date     "fecha_de_inicio",       :null => false
    t.date     "fecha_de_finalizacion", :null => false
    t.text     "observaciones"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "creator_id"
    t.integer  "updater_id"
  end

  add_index "convenios_de_administracion", ["efector_id"], :name => "unq_convenios_de_administracion_efector_id", :unique => true
  add_index "convenios_de_administracion", ["numero"], :name => "unq_convenios_de_administracion_numero", :unique => true

  create_table "convenios_de_gestion", :force => true do |t|
    t.string   "numero",                :null => false
    t.integer  "efector_id",            :null => false
    t.string   "firmante"
    t.string   "email_notificacion"
    t.date     "fecha_de_suscripcion"
    t.date     "fecha_de_inicio",       :null => false
    t.date     "fecha_de_finalizacion", :null => false
    t.text     "observaciones"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "creator_id"
    t.integer  "updater_id"
  end

  add_index "convenios_de_gestion", ["efector_id"], :name => "unq_convenios_de_gestion_efector_id", :unique => true
  add_index "convenios_de_gestion", ["numero"], :name => "unq_convenios_de_gestion_numero", :unique => true

  create_table "cuasi_facturas", :force => true do |t|
    t.integer  "liquidacion_id",                                       :null => false
    t.integer  "efector_id",                                           :null => false
    t.integer  "nomenclador_id",                                       :null => false
    t.date     "fecha_de_presentacion",                                :null => false
    t.string   "numero_de_liquidacion",                                :null => false
    t.decimal  "total_informado",       :precision => 15, :scale => 4
    t.text     "observaciones"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "creator_id"
    t.integer  "updater_id"
  end

  create_table "datos_adicionales", :force => true do |t|
    t.string   "nombre",                 :null => false
    t.string   "tipo_postgres",          :null => false
    t.string   "tipo_ruby",              :null => false
    t.boolean  "enumerable"
    t.string   "clase_para_enumeracion"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "datos_adicionales_por_prestacion", :force => true do |t|
    t.integer  "dato_adicional_id"
    t.integer  "prestacion_id"
    t.boolean  "obligatorio"
    t.string   "metodo_de_validacion"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "departamentos", :force => true do |t|
    t.string  "nombre",                :null => false
    t.integer "provincia_id",          :null => false
    t.integer "departamento_bio_id"
    t.string  "departamento_indec_id"
    t.integer "departamento_insc_id"
  end

  create_table "dependencias_administrativas", :force => true do |t|
    t.string "nombre",              :null => false
    t.string "tipo_de_dependencia"
  end

  create_table "discapacidades", :force => true do |t|
    t.string "nombre"
    t.string "codigo"
  end

  create_table "distritos", :force => true do |t|
    t.string   "nombre",            :null => false
    t.integer  "departamento_id",   :null => false
    t.string   "codigo_postal"
    t.integer  "distrito_bio_id"
    t.integer  "distrito_insc_id"
    t.string   "distrito_indec_id"
    t.integer  "alias_id",          :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "efectores", :force => true do |t|
    t.string   "cuie"
    t.string   "codigo_de_efector_sissa"
    t.integer  "codigo_de_efector_bio"
    t.string   "nombre",                                           :null => false
    t.string   "domicilio"
    t.integer  "departamento_id"
    t.integer  "distrito_id"
    t.string   "codigo_postal"
    t.string   "latitud"
    t.string   "longitud"
    t.string   "telefonos"
    t.string   "email"
    t.integer  "grupo_de_efectores_id"
    t.integer  "area_de_prestacion_id"
    t.integer  "camas_de_internacion"
    t.integer  "ambientes"
    t.integer  "dependencia_administrativa_id"
    t.boolean  "integrante",                    :default => true,  :null => false
    t.text     "observaciones"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.boolean  "alto_impacto",                  :default => false
    t.boolean  "perinatal_de_alta_complejidad", :default => false
    t.boolean  "addenda_perinatal",             :default => false
    t.date     "fecha_de_addenda_perinatal"
  end

  create_table "estados_de_las_novedades", :force => true do |t|
    t.string "nombre"
    t.string "codigo"
  end

  create_table "estados_de_las_prestaciones", :force => true do |t|
    t.string "nombre"
  end

  create_table "grupos_de_efectores", :force => true do |t|
    t.string  "nombre",                        :null => false
    t.string  "tipo_de_efector",               :null => false
    t.integer "grupo_bio_id"
    t.boolean "centro_integrador_comunitario"
  end

  create_table "grupos_de_prestaciones", :force => true do |t|
    t.string "nombre", :null => false
  end

  create_table "lenguas_originarias", :force => true do |t|
    t.string "nombre"
  end

  create_table "liquidaciones", :force => true do |t|
    t.integer  "efector_id",                                                :null => false
    t.integer  "mes_de_prestaciones",                                       :null => false
    t.integer  "anio_de_prestaciones",                                      :null => false
    t.date     "fecha_de_recepcion",                                        :null => false
    t.string   "numero_de_expediente",                                      :null => false
    t.date     "fecha_de_notificacion"
    t.date     "fecha_de_transferencia"
    t.date     "fecha_de_orden_de_pago"
    t.decimal  "total_facturado",            :precision => 15, :scale => 4
    t.decimal  "total_de_bajas_algebraicas", :precision => 15, :scale => 4
    t.decimal  "total_de_bajas_formales",    :precision => 15, :scale => 4
    t.decimal  "total_de_bajas_tecnicas",    :precision => 15, :scale => 4
    t.decimal  "total_a_procesar",           :precision => 15, :scale => 4
    t.decimal  "total_de_rechazos",          :precision => 15, :scale => 4
    t.decimal  "total_de_aceptaciones",      :precision => 15, :scale => 4
    t.decimal  "debitos_ugsp",               :precision => 15, :scale => 4
    t.decimal  "debitos_ace",                :precision => 15, :scale => 4
    t.decimal  "total_a_liquidar",           :precision => 15, :scale => 4
    t.text     "observaciones"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "creator_id"
    t.integer  "updater_id"
  end

  create_table "motivos_de_rechazos", :force => true do |t|
    t.string   "nombre"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "niveles_de_instruccion", :force => true do |t|
    t.string "nombre"
    t.string "codigo"
  end

  create_table "nomencladores", :force => true do |t|
    t.string   "nombre",                             :null => false
    t.date     "fecha_de_inicio",                    :null => false
    t.boolean  "activo",          :default => false, :null => false
    t.text     "observaciones"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "paises", :force => true do |t|
    t.integer "pais_bio_id"
    t.string  "nombre"
    t.string  "nombre_largo"
  end

  create_table "parametros", :force => true do |t|
    t.string   "nombre"
    t.string   "tipo_postgres"
    t.string   "tipo_ruby"
    t.text     "valor"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "creator_id"
    t.integer  "updater_id"
  end

  create_table "percentiles_pc_edad", :force => true do |t|
    t.string "nombre"
    t.string "codigo_para_prestaciones"
  end

  create_table "percentiles_peso_edad", :force => true do |t|
    t.string "nombre",                   :null => false
    t.string "codigo_para_prestaciones", :null => false
  end

  create_table "percentiles_peso_talla", :force => true do |t|
    t.string   "nombre"
    t.string   "codigo_para_prestaciones"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "percentiles_talla_edad", :force => true do |t|
    t.string "nombre"
    t.string "codigo_para_prestaciones"
  end

  create_table "periodos_de_actividad", :force => true do |t|
    t.integer  "afiliado_id"
    t.date     "fecha_de_inicio"
    t.date     "fecha_de_finalizacion"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "prestaciones", :force => true do |t|
    t.integer  "area_de_prestacion_id",                         :null => false
    t.integer  "grupo_de_prestaciones_id",                      :null => false
    t.integer  "subgrupo_de_prestaciones_id"
    t.string   "codigo",                                        :null => false
    t.string   "nombre",                                        :null => false
    t.integer  "unidad_de_medida_id",                           :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "activa",                      :default => true
  end

  create_table "prestaciones_autorizadas", :force => true do |t|
    t.integer  "efector_id",                  :null => false
    t.integer  "prestacion_id",               :null => false
    t.date     "fecha_de_inicio",             :null => false
    t.integer  "autorizante_al_alta_id"
    t.string   "autorizante_al_alta_type"
    t.date     "fecha_de_finalizacion"
    t.integer  "autorizante_de_la_baja_id"
    t.string   "autorizante_de_la_baja_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "creator_id"
    t.integer  "updater_id"
  end

  create_table "provincias", :force => true do |t|
    t.string  "nombre",           :null => false
    t.integer "provincia_bio_id"
  end

  create_table "referentes", :force => true do |t|
    t.integer  "efector_id",            :null => false
    t.integer  "contacto_id",           :null => false
    t.text     "observaciones"
    t.date     "fecha_de_inicio",       :null => false
    t.date     "fecha_de_finalizacion"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "creator_id"
    t.integer  "updater_id"
  end

  create_table "registros_de_datos_adicionales", :force => true do |t|
    t.integer  "registro_de_prestacion_id", :null => false
    t.integer  "dato_adicional_id",         :null => false
    t.text     "valor"
    t.text     "observaciones"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "creator_id"
    t.integer  "updater_id"
  end

  create_table "registros_de_prestaciones", :force => true do |t|
    t.date     "fecha_de_prestacion"
    t.string   "apellido"
    t.string   "nombre"
    t.integer  "clase_de_documento_id",          :default => 1
    t.integer  "tipo_de_documento_id",           :default => 1
    t.integer  "numero_de_documento"
    t.string   "codigo_de_prestacion_informado"
    t.integer  "prestacion_id"
    t.integer  "cantidad",                       :default => 1
    t.string   "historia_clinica"
    t.integer  "estado_de_la_prestacion_id"
    t.integer  "motivo_de_rechazo_id"
    t.integer  "cuasi_factura_id"
    t.integer  "nomenclador_id"
    t.integer  "afiliado_id"
    t.text     "observaciones"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "creator_id"
    t.integer  "updater_id"
  end

  create_table "renglones_de_cuasi_facturas", :force => true do |t|
    t.integer  "cuasi_factura_id",                                              :null => false
    t.string   "codigo_de_prestacion_informado"
    t.integer  "prestacion_id"
    t.integer  "cantidad_informada"
    t.decimal  "monto_informado",                :precision => 15, :scale => 4
    t.decimal  "subtotal_informado",             :precision => 15, :scale => 4
    t.integer  "cantidad_digitalizada"
    t.integer  "cantidad_aceptada"
    t.text     "observaciones"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "creator_id"
    t.integer  "updater_id"
  end

  create_table "sexos", :force => true do |t|
    t.string "nombre"
    t.string "codigo"
  end

  create_table "si_no", :force => true do |t|
    t.string   "nombre"
    t.string   "codigo"
    t.boolean  "valor_bool"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subgrupos_de_prestaciones", :force => true do |t|
    t.integer "grupo_de_prestaciones_id", :null => false
    t.string  "nombre",                   :null => false
  end

  create_table "tipos_de_documentos", :force => true do |t|
    t.string "nombre"
    t.string "codigo"
  end

  create_table "tipos_de_novedades", :force => true do |t|
    t.string "nombre"
    t.string "codigo"
  end

  create_table "tribus_originarias", :force => true do |t|
    t.string "nombre"
  end

  create_table "unidades_de_alta_de_datos", :force => true do |t|
    t.string   "nombre",                           :null => false
    t.string   "codigo",                           :null => false
    t.boolean  "inscripcion",   :default => false
    t.boolean  "facturacion",   :default => false
    t.boolean  "activa",        :default => true
    t.text     "observaciones"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.integer  "creator_id"
    t.integer  "updater_id"
  end

  add_index "unidades_de_alta_de_datos", ["codigo"], :name => "index_unidades_de_alta_de_datos_on_codigo", :unique => true

  create_table "unidades_de_alta_de_datos_users", :id => false, :force => true do |t|
    t.integer  "unidad_de_alta_de_datos_id",                   :null => false
    t.integer  "user_id",                                      :null => false
    t.boolean  "predeterminada",             :default => true
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
  end

  create_table "unidades_de_medida", :force => true do |t|
    t.string "nombre", :null => false
  end

  create_table "user_groups", :force => true do |t|
    t.string   "user_group_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "user_group_description"
  end

  create_table "user_groups_users", :id => false, :force => true do |t|
    t.integer  "user_group_id"
    t.integer  "user_id"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "user_groups_users", ["user_group_id", "user_id"], :name => "index_user_groups_users_on_user_group_id_and_user_id", :unique => true

  create_table "users", :force => true do |t|
    t.string   "nombre",                                    :null => false
    t.string   "apellido",                                  :null => false
    t.date     "fecha_de_nacimiento"
    t.integer  "sexo_id"
    t.text     "observaciones"
    t.boolean  "authorized",             :default => false, :null => false
    t.datetime "authorized_at"
    t.integer  "authorized_by"
    t.string   "email",                  :default => "",    :null => false
    t.string   "encrypted_password",     :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["unlock_token"], :name => "index_users_on_unlock_token", :unique => true

end
