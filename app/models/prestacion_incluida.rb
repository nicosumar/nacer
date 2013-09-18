class PrestacionIncluida < ActiveRecord::Base

  has_many :prestaciones_liquidadas
  
end
