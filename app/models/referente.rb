class Referente < ActiveRecord::Base
  # NULLificar los campos de texto en blanco
  nilify_blanks

  # Los atributos siguientes pueden asignarse en forma masiva
  attr_accessible :efector_id, :contacto_id, :fecha_de_inicio, :fecha_de_finalizacion, :observaciones

  # Los atributos siguientes solo pueden asignarse durante la creación
  attr_readonly :efector_id

  # Asociaciones
  belongs_to :efector
  belongs_to :contacto

  # Validaciones
  validates_presence_of :efector_id, :contacto_id, :fecha_de_inicio
  validate :validar_fechas

  #
  # validar_fechas
  # Verifica que las fechas de inicio y fin tengan valores lógicos y que los periodos no se superpongan en el tiempo
  # con los de otro referente.
  def validar_fechas
    error_de_fecha = false

    # Verificar que la fecha de inicio no sea posterior a la de finalización
    if fecha_de_finalizacion && fecha_de_inicio && fecha_de_finalizacion < fecha_de_inicio
      errors.add(:fecha_de_finalizacion, "debe ser posterior a la fecha de inicio.")
      error_de_fecha = true
    end

    # Obtener los referentes de este efector
    referentes = Referente.where({:efector_id => efector_id}, {:include => :contacto})
    referentes.each do |r|
      # Verificar que ninguno de los otros referentes se superponga en el tiempo con este que se modifica / crea
      if r.id != id
        case
          when fecha_de_inicio < r.fecha_de_inicio && (fecha_de_finalizacion.nil? || fecha_de_finalizacion >= r.fecha_de_inicio)
            errors.add(:fecha_de_inicio,
              "crearía un periodo que se superpone con el de otro referente (" + r.contacto.mostrado + ")."
            )
            if fecha_de_finalizacion
              errors.add(:fecha_de_finalizacion,
                "crearía un periodo que se superpone con el de otro referente (" + r.contacto.mostrado + ")."
              )
            end
            error_de_fecha = true
          when fecha_de_inicio >= r.fecha_de_inicio && r.fecha_de_finalizacion && fecha_de_inicio < r.fecha_de_finalizacion
            errors.add(:fecha_de_inicio,
              "crearía un periodo que se superpone con el de otro referente (" + r.contacto.mostrado + ")."
            )
            if fecha_de_finalizacion
              errors.add(:fecha_de_finalizacion,
                "crearía un periodo que se superpone con el de otro referente (" + r.contacto.mostrado + ")."
              )
            end
            error_de_fecha = true
        end
      end
    end

    return !error_de_fecha
  end

  #
  # actual?
  # Indica si este es el referente actual
  def actual?()
    fecha_de_finalizacion.nil?
  end

  #
  # self.actual_del_efector
  # Devuelve el referente actual del ID de efector pasado como parámetro
  def self.actual_del_efector(efector)
    Referente.where("efector_id = '?' AND fecha_de_finalizacion IS NULL", efector).first
  end
end
