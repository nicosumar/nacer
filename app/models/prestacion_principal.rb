class PrestacionPrincipal < ActiveRecord::Base
  attr_accessible :activa, :codigo, :deleted_at, :nombre, :prestaciones, :prestaciones_attributes, :prestacion_ids
  
  has_many :prestaciones
  has_many :prestaciones_pdss, through: :prestaciones  

  scope :activas,->{}
  scope :like_codigo, ->(codigo) { where("prestaciones_principales.codigo LIKE ?", "%#{codigo.upcase}%") if codigo.present? }

  before_validation :populate_attributes
  after_save :validar_prestaciones

  accepts_nested_attributes_for :prestaciones, reject_if: :all_blank, allow_destroy: false

  def full_codigo_y_nombre
    "#{self.codigo} - #{nombre}"
  end

  private
    def populate_attributes
      prestacion_modelo = nil
      self.prestaciones.each do |prestacion|
        if !prestacion.new_record? and prestacion_modelo.blank?
          prestacion_modelo = prestacion
          break
        end
      end
      if prestacion_modelo.present?   
        control = false     
        self.prestaciones.map! do |prestacion|
          if prestacion.new_record?
            control = true
            prestaciones_pdss = prestacion.prestaciones_pdss
            prestaciones_pdss = prestaciones_pdss.each do |pdss|
              pdss.nombre = prestacion.nombre
            end
            prestacion = prestacion_modelo.duplicar
            prestacion.prestaciones_pdss = prestaciones_pdss
            prestacion.prestacion_principal = self            
          end
          prestacion
        end
        if control
          self.prestaciones.build
          self.reload
        end
      end
      self
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