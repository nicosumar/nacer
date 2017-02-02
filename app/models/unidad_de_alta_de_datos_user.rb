# -*- encoding : utf-8 -*-
class UnidadDeAltaDeDatosUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :unidad_de_alta_de_datos
end
