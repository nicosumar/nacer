# -*- encoding : utf-8 -*-
Nacer::Application.routes.draw do

  devise_for :users, :controllers => { :sessions => "user_sessions", :registrations => "users" }
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
  resources :efectores, :except => :destroy do
    get 'prestaciones_autorizadas', :on => :member, :as => :prestaciones_autorizadas_del
    get 'referentes', :on => :member, :as => :referentes_del
  end
  resources :addendas, :except => :destroy
  resources :nomencladores, :except => :destroy
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
  resources :novedades_de_los_afiliados, :except => [:new, :create] do
    get 'alta', :on => :collection, :as => :new_alta, :action => :new_alta
    get 'baja', :on => :collection, :as => :new_baja, :action => :new_baja
    get 'modificacion', :on => :collection, :as => :new_modificacion, :action => :new_modificacion
    post 'alta', :on => :collection, :as => :create_alta, :action => :create_alta
    post 'baja', :on => :collection, :as => :create_baja, :action => :create_baja
    post 'modificacion', :on => :collection, :as => :create_modificacion, :action => :create_modificacion
  end
  resources :afiliados, :only => [:show]
  resources :unidades_de_alta_de_datos, :except => :destroy
  match "informe_de_beneficiarios_activos" => "informes#beneficiarios_activos"
  match "tablero_de_comandos_alto_impacto" => "informes#tablero_de_comandos_alto_impacto"

  root :to => 'inicio#index'

end
