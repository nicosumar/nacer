# -*- encoding : utf-8 -*-
Nacer::Application.routes.draw do

  scope '/(:locale)', defaults: { locale: 'es' }, constraints: { locale: /es|en/ } do
    authenticated :user, -> user { user.in_group? [:administradores,:facturacion]} do
      mount Delayed::Web::Engine => '/jobs'
    end
  end
  
  resources :procesos_de_sistemas , :only => [:index,:destroy,:show] 

  get "datos_reportables/show"
  get "prestaciones/autorizadas"
  get "diagnosticos/por_prestacion"

  # Informes de rendicion
  resources :informes_de_rendicion
  #match 'users/:user_id/informes_de_rendicion/create' => 'informes_de_rendicion#create', :via => :post

  resources :documentos_generables
  resources :notas_de_debito
  resources :prestaciones_principales

  resources :informes_debitos_prestacionales do
    resources :detalles_de_debitos_prestacionales, only: [:index, :create, :destroy]
    put :iniciar, on: :member
    put :finalizar, on: :member
    put :cerrar, on: :member
  end

  resources :expedientes_sumar do
    get 'generar_caratulas_expedientes_por_liquidacion', as: :generar_caratulas_expedientes_por_liquidacion, action: :generar_caratulas_expedientes_por_liquidacion, on: :member
  end

  get "documentos_electronicos/index"
  get "capacitaciones/index"

  get 'buscar_prestacion_liquidada/:action' => 'prestaciones_liquidadas#:action'
  get 'buscar_prestacion_liquidada/por_afiliado_concepto_y_efector' => 'prestaciones_liquidadas#por_afiliado_concepto_y_efector', as: :prestaciones_liquidadas_por_afiliado_efector_concepto

  #Liquidaciones - Sumar
  resources :conceptos_de_facturacion do
    resources :documentos_generables_por_conceptos, only: [:index, :create, :destroy]
  end
  resources :periodos
  resources :tipos_periodos
  resources :formulas
  resources :grupos_de_efectores_liquidaciones

  resources :liquidaciones_sumar do
    get '/efectores/:id', to: 'liquidaciones_sumar#detalle_de_prestaciones_liquidadas_por_efector', as: 'detalle_de_prestaciones_liquidadas_por_efector'
    member do
      post   'procesar_liquidaciones',  as: :procesar_liquidaciones, action: :procesar_liquidaciones
      post   'procesar_liquidacion', as: :procesar_liquidacion, action: :procesar_liquidacion
      post   'generar_cuasifacturas', as: :generar_cuasifacturas, action: :generar_cuasifacturas
      delete 'vaciar_liquidacion', :as => :vaciar_liquidacion, :action => :vaciar_liquidacion
    end
  end
  
  resources :solicitudes_addendas do
    member do
         post   'confirmar_solicitud', as: :confirmar_solicitud, action: :confirmar_solicitud
         post   'aprobacion_tecnica' , as: :aprobacion_tecnica, action: :aprobacion_tecnica
         post   'aprobacion_legal'   , as: :aprobacion_legal, action: :aprobacion_legal
         post   'anular_solicitud'   , as: :anular_solicitud, action: :anular_solicitud
    end
  end
  
  
  resources :reglas
  resources :liquidaciones_sumar_anexos_administrativos do
    put :finalizar_anexo, on: :member
  end
  resources :liquidaciones_sumar_anexos_medicos do
    put :finalizar_anexo, on: :member
  end
  resources :plantillas_de_reglas
  # resources :liquidaciones_sumar_cuasifacturas_detalles
  resources :liquidaciones_sumar_cuasifacturas
  resources :parametros_liquidaciones_sumar
  resources :liquidaciones_informes do
    member do
      post 'cerrar', as: :cerrar, action: :cerrar
    end
  end

  resources :secciones_pdss, only: [] do
    resources :grupos_pdss, only: :index
  end

  resources :grupos_pdss, only: [] do
    resources :grupos_poblacionales, only: :index
    resources :sexos, only: :index
  end

  resources :consolidados_sumar
  # rutas para la actualizacion asincronica
  resources :anexos_medicos_prestaciones, :only => [] do
    put :update_status, on: :member
    put :update_motivo_rechazo, on: :member
  end
  resources :anexos_administrativos_prestaciones, :only => [] do
    put :update_status, on: :member
    put :update_motivo_rechazo, on: :member
  end

  resources :datos_reportables , :only => :show

  devise_for :users, :controllers => { :sessions => "user_sessions", :registrations => "users", :passwords => "passwords" }
  devise_scope :user do
    get "users", :to => "users#index", :as => :users
    get "users/:id", :to => "users#admin_edit", :as => :user
    get "users/:id/edit", :to => "users#admin_edit", :as => :edit_user
    put "users/:id", :to => "users#admin_update"
    get "seleccionar_uad" => "user_sessions#seleccionar_uad", :as => :seleccionar_uad
    delete "users/:id", :to => "users#destroy", :as => :delete_user
  end
  resources :convenios_de_administracion, :except => :destroy
  resources :convenios_de_gestion, :except => :destroy do
    get 'addendas', :on => :member, :as => :addendas_del
  end
  resources :convenios_de_administracion_sumar, :except => :destroy
  resources :convenios_de_gestion_sumar, :except => :destroy do
    get 'addendas', :on => :member, :as => :addendas_del
    get 'firmante', :on => :member
  end
  resources :efectores, :except => :destroy do
    get 'prestaciones_autorizadas', :on => :member, :as => :prestaciones_autorizadas_del
    get 'referentes', :on => :member, :as => :referentes_del
  end
  resources :paises, :except => :destroy
  resources :provincias, :except => :destroy
  resources :departamentos, :except => :destroy
  resources :distritos, :except => :destroy
  resources :informes, :except => :destroy do
    get "informe_solicitado", on: :collection, as: :render_informe_default, action: :render_informe
  end
  resources :addendas, :except => :destroy
  resources :addendas_sumar, :except => :destroy do
    get 'new_masivo', :on => :collection, :as => :new_masivo
    post 'create_masivo', :on => :collection, :as => :create_masivo
  end
  resources :nomencladores, :except => :destroy do
    get 'asignar_precios', :on => :member, :as => :new_asignar_precios, :action => :new_asignar_precios
    get 'grupo_pdss/:grupo_pdss_id/asignar_precios', :on => :member, :as => :new_asignar_precios_por_grupo_pdss, :action => :new_asignar_precios_por_grupo_pdss
    put 'update_asignar_precios', :on => :member, :as => :update_asignar_precios, :action => :update_asignar_precios
  end
  resources :busqueda, :only => :index
  resources :verificador, :only => :index
  resources :padrones, :only => :index do
    post 'cierre', :on => :collection, :as => :cierre_de
  end
  resources :referentes, :except => [:index, :show, :destroy]
  resources :contactos, :except => :destroy
  resources :liquidaciones, :except => :destroy
  resources :cuasi_facturas, :except => :destroy
  match "importar_detalle" => "cuasi_facturas#importar_detalle"
  match "importar_registros_de_prestaciones" => "cuasi_facturas#importar_registros_de_prestaciones"
  match "importar_archivo_p" => "liquidaciones#importar_archivo_p"
  match "procesar_bajas" => "novedades_de_los_afiliados#procesar_bajas"
  resources :novedades_de_los_afiliados, :except => [:new, :create] do
    get 'alta', :on => :collection, :as => :new_alta, :action => :new_alta
    get 'baja', :on => :collection, :as => :new_baja, :action => :new_baja
    get 'modificacion', :on => :collection, :as => :new_modificacion, :action => :new_modificacion
    post 'alta', :on => :collection, :as => :create_alta, :action => :create_alta
    post 'baja', :on => :collection, :as => :create_baja, :action => :create_baja
    post 'modificacion', :on => :collection, :as => :create_modificacion, :action => :create_modificacion
  end
  resources :afiliados, :only => [:show] do
    get :busqueda_por_aproximacion, on: :collection
    get 'prestaciones_brindadas', :on => :member, :as => :prestaciones_brindadas_al
  end
  resources :unidades_de_alta_de_datos, :except => :destroy
  resources :prestaciones_brindadas
  match "informe_de_beneficiarios_activos" => "informes#beneficiarios_activos"
  match "tablero_de_comandos_alto_impacto" => "informes#tablero_de_comandos_alto_impacto"
  resources :procesos_de_datos_externos, :except => :destroy do
    member do
      post 'aplicar', :as => :aplicar, :action => :aplicar
      post 'iniciar', :as => :iniciar, :action => :iniciar
    end
  end

  resources :prestaciones do
    get :validar_codigo , on: :collection
    get :edit_para_asignacion_de_precios, on: :member
  end
 
  resources :solicitudes_addendas, :except => :destroy
  

  root :to => 'inicio#index'


 

end

