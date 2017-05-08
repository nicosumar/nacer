class TipoProcesoDeSistema < ActiveRecord::Base
  attr_accessible :nombre
  has_many :procesos_de_sistemas
end
