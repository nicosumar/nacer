class EstadoSolicitudAddenda < ActiveRecord::Base
  attr_accessible :codigo, :indexable, :nombre, :pendiente
  has_many :solicitud_addenda
end
