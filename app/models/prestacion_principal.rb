class PrestacionPrincipal < ActiveRecord::Base
  attr_accessible :activa, :codigo, :deleted_at, :nombre, :prestaciones, :prestaciones_attributes, :prestacion_ids
  
  has_many :prestaciones
  has_many :prestaciones_pdss, through: :prestaciones  

  scope :activas,->{}

  before_save :populate_attributes
  after_save :validar_prestaciones

  accepts_nested_attributes_for :prestaciones, reject_if: :all_blank, allow_destroy: false

  def full_codigo_y_nombre
    "#{self.codigo} - #{nombre}"
  end

  private
    def populate_attributes
      
    end

    def validar_prestaciones
      self.prestaciones.each do |prestacion|
        if prestacion.prestaciones_pdss.count > 1
          first_record = true
          prestacion.prestaciones_pdss.each do |prestacion_pdss|
            if !first_record
              nueva_prestacion = prestacion.duplicar
              prestacion_pdss.prestaciones = [nueva_prestacion]
              prestacion_pdss.save
            end
            first_record = false
          end
        end
      end
    end
end