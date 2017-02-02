# -*- encoding : utf-8 -*-
class VistaGlobalDePrestacionBrindada < ActiveRecord::Base

  # Todos los atributos son solo para lectura porque es un modelo "falso" que referencia una vista y no una tabla
  # Lo pongo por seguridad
  attr_readonly :cantidad_de_unidades, :clave_de_beneficiario, :cuasi_factura_id, :diagnostico_id, :efector_id
  attr_readonly :es_catastrofica, :estado_de_la_prestacion_id, :fecha_de_la_prestacion, :fecha_del_debito, :mensaje_de_la_baja
  attr_readonly :monto_facturado, :monto_liquidado, :nomenclador_id, :observaciones, :prestacion_id
  attr_readonly :historia_clinica, :clave_de_beneficiario, :efector_id, :fecha_de_la_prestacion, :prestacion_id, :esquema

  # Asociaciones
  belongs_to :diagnostico
  belongs_to :efector
  belongs_to :estado_de_la_prestacion
  belongs_to :nomenclador
  belongs_to :prestacion

  def beneficiario
    beneficiario =
    VistaGlobalDeNovedadDelAfiliado.where(
      :esquema => esquema,
      :clave_de_beneficiario => clave_de_beneficiario,
      :estado_de_la_novedad_id => EstadoDeLaNovedad.where(:codigo => ["R", "P"]),
      :tipo_de_novedad_id => TipoDeNovedad.where(:codigo => ["A", "M"])
    ).first
    if not beneficiario
      beneficiario = Afiliado.find_by_clave_de_beneficiario(clave_de_beneficiario)
    end

    return beneficiario
  end

  def unidad_de_alta_de_datos
    UnidadDeAltaDeDatos.find_by_codigo(self.esquema[4,3])
  end

end
