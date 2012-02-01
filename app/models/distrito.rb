class Distrito < ActiveRecord::Base
  belongs_to :departamento

  validates_presence_of :nombre, :departamento_id, :alias_id

  def nombre_corto
    if nombre.length > 80 then
      nombre.first(77) + "..."
    else
      nombre
    end
  end
end
