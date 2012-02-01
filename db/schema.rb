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

ActiveRecord::Schema.define(:version => 20111222161515) do

  create_table "addendas", :force => true do |t|
    t.integer  "convenio_de_gestion_id", :null => false
    t.string   "firmante"
    t.date     "fecha_de_suscripcion"
    t.date     "fecha_de_inicio",        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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

  create_table "contactos", :force => true do |t|
    t.string   "nombres",         :null => false
    t.string   "apellidos",       :null => false
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
  end

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
    t.string   "cuie",                          :null => false
    t.string   "efector_sissa_id"
    t.integer  "efector_bio_id"
    t.string   "nombre",                        :null => false
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
    t.boolean  "integrante",                    :null => false
    t.boolean  "evaluacion_de_impacto"
    t.text     "observaciones"
    t.datetime "created_at"
    t.datetime "updated_at"
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

  create_table "nomencladores", :force => true do |t|
    t.string   "nombre",                             :null => false
    t.date     "fecha_de_inicio",                    :null => false
    t.boolean  "activo",          :default => false, :null => false
    t.text     "observaciones"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "prestaciones", :force => true do |t|
    t.integer  "area_de_prestacion_id",       :null => false
    t.integer  "grupo_de_prestaciones_id",    :null => false
    t.integer  "subgrupo_de_prestaciones_id"
    t.string   "codigo",                      :null => false
    t.string   "nombre",                      :null => false
    t.integer  "unidad_de_medida_id",         :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
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
  end

  create_table "provincias", :force => true do |t|
    t.string  "nombre",           :null => false
    t.integer "provincia_bio_id"
  end

  create_table "referentes", :force => true do |t|
    t.integer  "efector_id",            :null => false
    t.integer  "contacto_id",           :null => false
    t.text     "observaciones"
    t.date     "fecha_de_inicio"
    t.date     "fecha_de_finalizacion"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subgrupos_de_prestaciones", :force => true do |t|
    t.integer "grupo_de_prestaciones_id", :null => false
    t.string  "nombre",                   :null => false
  end

  create_table "unidades_de_medida", :force => true do |t|
    t.string "nombre", :null => false
  end

  create_table "user_groups", :force => true do |t|
    t.string   "user_group_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_groups_users", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "user_group_id"
  end

  create_table "users", :force => true do |t|
    t.string   "firstname",         :null => false
    t.string   "lastname",          :null => false
    t.string   "login",             :null => false
    t.string   "email",             :null => false
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
