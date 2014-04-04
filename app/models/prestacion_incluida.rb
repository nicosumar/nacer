class PrestacionIncluida < ActiveRecord::Base

  has_many :prestaciones_liquidadas
  belongs_to :prestacion 
  
end
