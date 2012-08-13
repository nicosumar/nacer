Nacer::Application.routes.draw do

  match "iniciar_sesion" => "user_sessions#new"
  match "cerrar_sesion" => "user_sessions#destroy"

  resources :users, :except => [:show, :destroy]
  resources :user_groups
  resources :user_sessions, :only => [:new, :create, :destroy]
  resources :convenios_de_administracion, :except => :destroy
  resources :convenios_de_gestion, :except => :destroy
  resources :efectores, :except => :destroy
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
  resources :novedades_de_los_afiliados, :except => :destroy
  resources :afiliados, :only => [:index, :show]

  root :to => 'inicio#index'

end
