class PrestacionPrincipal < ActiveRecord::Base
  attr_accessible :activa, :codigo, :deleted_at, :nombre, :prestaciones, :prestaciones_attributes, :prestacion_ids
  
  has_many :prestaciones
  has_many :prestaciones_pdss ,:through => :prestaciones 
  has_many :prestaciones_pdss_activas, :through => :prestaciones ,:class_name =>  "PrestacionPdss", :source =>:prestaciones_pdss, :conditions => {"prestaciones.activa" => true}
  has_many :prestaciones_pdss_inactivas, :through => :prestaciones ,:class_name =>  "PrestacionPdss", :source =>:prestaciones_pdss, :conditions => {"prestaciones.activa" => false}

  has_many :solicitudes_adddendas_prestaciones_principales
  
  scope :activas,->{}
  scope :like_codigo, ->(codigo) { where("prestaciones_principales.codigo LIKE ?", "%#{codigo.upcase}%") if codigo.present? }

  validates_presence_of :codigo, :nombre

  before_validation :populate_attributes
  after_save :validar_prestaciones

  accepts_nested_attributes_for :prestaciones, reject_if: :all_blank, allow_destroy: false
  
  def full_codigo_y_nombre
    "#{self.codigo} - #{nombre}"
  end

  private
    def populate_attributes
      self
    end

    def validar_prestaciones
      self.prestaciones.each do |prestacion|
        if prestacion.prestaciones_pdss.count > 1 and (prestacion.activa == true or prestacion.activa == nil)
          first_record = true
          prestacion.prestaciones_pdss.each do |prestacion_pdss|
            nueva_prestacion = prestacion.duplicar
            prestacion_pdss.prestaciones = [nueva_prestacion]
            if prestacion_pdss.save
              # Genero el histórico de la prestación.
              HistoricoPrestacion.create(prestacion: nueva_prestacion, prestacion_anterior: prestacion)
            end
          end
          prestacion.activa = false
          prestacion.save
        end
      end
    end
end
