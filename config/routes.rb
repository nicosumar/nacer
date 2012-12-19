# -*- encoding : utf-8 -*-
Nacer::Application.routes.draw do

  devise_for :users, :controllers => { :sessions => "user_sessions", :registrations => "users" }
  devise_scope :user do
    get "users", :to => "users#index", :as => :users
    get "users/:id/edit", :to => "users#admin_edit", :as => :edit_user
    put "users/:id", :to => "users#admin_update", :as => :user
    get "seleccionar_uad" => "user_sessions#seleccionar_uad", :as => :seleccionar_uad
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
  resources :padrones, :only => :index
  resources :referentes, :except => [:index, :show, :destroy]
  resources :contactos, :except => :destroy
  resources :liquidaciones, :except => :destroy
  resources :cuasi_facturas, :except => :destroy
  match "importar_detalle" => "cuasi_facturas#importar_detalle"
  match "importar_registros_de_prestaciones" => "cuasi_facturas#importar_registros_de_prestaciones"
  match "importar_archivo_p" => "liquidaciones#importar_archivo_p"
  resources :novedades_de_los_afiliados, :only => [:index, :show, :edit, :destroy] do
    get 'alta', :on => :collection, :as => :new_alta, :action => :new_alta
    get 'baja', :on => :collection, :as => :new_baja, :action => :new_baja
    get 'modificacion', :on => :collection, :as => :new_modificacion, :action => :new_modificacion
    post 'alta', :on => :collection, :as => :create_alta, :action => :create_alta
    post 'baja', :on => :collection, :as => :create_baja, :action => :create_baja
    post 'modificacion', :on => :collection, :as => :create_modificacion, :action => :create_modificacion
    put 'alta', :on => :member, :as => :update_alta, :action => :update_alta
    put 'baja', :on => :member, :as => :update_baja, :action => :update_baja
    put 'modificacion', :on => :member, :as => :update_modificacion, :action => :update_modificacion
  end
  resources :afiliados, :only => [:show]
  resources :unidades_de_alta_de_datos, :except => :destroy

  root :to => 'inicio#index'

end
