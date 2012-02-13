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

  root :to => 'inicio#index'

end
