Nacer::Application.routes.draw do

  match "iniciar_sesion" => "user_sessions#new"
  match "cerrar_sesion" => "user_sessions#destroy"

  resources :users, :except => [:show, :destroy]
  resources :user_groups
  resources :user_sessions, :only => [:new, :create, :destroy]
  resources :distritos
  resources :contactos
  resources :convenios_de_administracion, :except => :destroy # Prohibir el borrado hasta analizarlo más en detalle
  resources :convenios_de_gestion, :except => :destroy # Prohibir el borrado hasta analizarlo más en detalle
  resources :asignaciones_de_nomenclador
  resources :asignaciones_de_precios
  resources :nomencladores
  resources :prestaciones
  resources :efectores, :except => :destroy
  resources :addendas, :except => :destroy # Prohibir el borrado hasta analizarlo más en detalle
  resources :nomencladores, :except => :destroy # Prohibir el borrado hasta analizarlo más en detalle
  resources :busqueda, :only => :index
  resources :verificador, :only => :index
  resources :padrones, :only => :index
  resources :referentes, :except => [:index, :show, :destroy]
  resources :contactos, :except => :destroy
  resources :liquidaciones, :except => :destroy
  resources :cuasi_facturas, :except => :destroy
  resources :renglones_de_cuasi_facturas, :except => [:index, :show, :destroy]
  match "importar_detalle" => "cuasi_facturas#importar_detalle"
  match "importar_registros_de_prestaciones" => "cuasi_facturas#importar_registros_de_prestaciones"
  match "importar_archivo_p" => "liquidaciones#importar_archivo_p"

  root :to => 'inicio#index'

end
