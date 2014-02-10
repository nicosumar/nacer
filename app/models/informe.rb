class Informe < ActiveRecord::Base
  has_many :informes_filtros
  has_many :informes_uads
  has_many :esquemas, :through => :informes_uads, :class_name => 'UnidadDeAltaDeDatos'
  
  accepts_nested_attributes_for :informes_filtros, :reject_if => :all_blank, :allow_destroy => true
  
  attr_accessible :titulo
  attr_accessible :sql
  attr_accessible :metodo
  attr_accessible :nombre_partial
  attr_accessible :formato
  attr_accessible :informes_filtros_attributes

  #"Sexy" validations
  validates :titulo, presence: true
  validates :nombre_partial, presence: true
  validates :formato, presence: true

  # validates :sql, presence: true

  validates_associated :informes_filtros
  
  def render(parametros=[])

    if self.sql.present?
      #traigo los parametros del reporte y los ordeno para el query
      valores = []
      parametros.sort.each { |p, v| valores << v} unless parametros.blank?

      #Al ser todos o incluidos o excluidos, busco los codigos, y despues verifico si se incluye o excluye
      if self.informes_uads.first.incluido == 1
        cq = CustomQuery.buscar (
          {
            esquemas: self.esquemas,
            sql: self.sql,
            values: valores
          })
      else
        cq = CustomQuery.buscar (
          {
            except: self.esquemas,
            sql: self.sql,
            values: valores
          })
      end
      
      return cq
    else # ruby code
      cq = CustomQuery.buscar({
          ruby: self.metodo,
          values: valores
        })

    end
  end


end
