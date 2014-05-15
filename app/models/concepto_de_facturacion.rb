# -*- encoding : utf-8 -*-
class ConceptoDeFacturacion < ActiveRecord::Base

  has_many :prestaciones, :inverse_of => :concepto_de_facturacion
  has_many :periodos, :inverse_of => :concepto_de_facturacion
  has_many :informes_debitos_prestacionales
  has_many :notas_de_debito
  has_many :documentos_generables_por_conceptos
  has_many :documentos_generables, through: :documentos_generables_por_conceptos
  belongs_to :formula

  attr_accessible :concepto, :descripcion, :prestaciones, :concepto_facturacion_id, :codigo, :formula_id, :dias_de_prestacion

  validates :concepto, presence: true
  validates :descripcion, presence: true
  validates :codigo, presence: true
  validates :formula_id, presence: true

  # Devuelve el id asociado con el código pasado
  def self.id_del_codigo(codigo)
    if codigo.blank?
      return nil
    end

    # Buscar el código en la tabla y devolver su ID (si existe)
    concepto = self.find_by_codigo(codigo.strip.upcase)
    if concepto.present?
      return concepto.id
    else
      return nil
    end
  end

  # Devuelve el id asociado con el código pasado, pero dispara una excepción si no lo encuentra
  def self.id_del_codigo!(codigo)
    codigo_id = self.id_del_codigo(codigo)
    raise ActiveRecord::RecordNotFound if codigo_id.nil?
    return codigo_id
  end

  # 
  # Genera los documentos asociados al concepto para una liquidación dada
  # @param  liquidacion [LiquidacionSumar] Objeto de la liquidación en curso
  # 
  # @return [Boolean] Si pudo generar todos los documentos.
  def generar_documentos(liquidacion)

    documentos_a_generar = self.documentos_generables_por_conceptos

    documentos_generables.each do |dgpc|
      eval("#{dgpc.documentos_generables.modelo}.generar_desde_liquidacion(liquidacion, dgpc.tipo_de_agrupacion)")
    end


    
  end

end
