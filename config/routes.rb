Nacer::Application.routes.draw do

  devise_for :users, :controllers => { :sessions => "user_sessions", :registrations => "users" }
  devise_scope :user do
    get "users", :to => "users#index", :as => :users
    get "users/:id/edit", :to => "users#admin_edit", :as => :edit_user
    put "users/:id", :to => "users#admin_update", :as => :user
    get "seleccionar_uad" => "user_sessions#seleccionar_uad", :as => :seleccionar_uad
  end
  resources :convenios_de_administracion, :except => :destroy
  resources :convenios_de_gestion, :except => :destroy
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
  resources :novedades_de_los_afiliados
  resources :afiliados, :only => [:index, :show]

  root :to => 'inicio#index'

end
