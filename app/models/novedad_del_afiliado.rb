class NovedadDelAfiliado < ActiveRecord::Base
  # Seguridad de asignaciones masivas
  attr_accessible :apellido, :nombre, :sexo, :fecha_de_nacimiento, :pais_de_nacimiento_id
  attr_accessible :se_declara_indigena, :lengua_originaria_id, :tribu_originaria_id
  attr_accessible :tipo_de_documento_de_la_madre_id, :numero_de_documento_de_la_madre
  attr_accessible :apellido_de_la_madre, :nombre_de_la_madre, :tipo_de_documento_del_padre_id
  attr_accessible :numero_de_documento_del_padre, :apellido_del_padre, :nombre_del_padre
  attr_accessible :tipo_de_documento_del_tutor_id, :numero_de_documento_del_tutor
  attr_accessible :apellido_del_tutor, :nombre_del_tutor, :fecha_de_diagnostico_del_embarazo
  attr_accessible :semanas_de_embarazo, :fecha_probable_de_parto, :fecha_efectiva_de_parto
  attr_accessible :domicilio_calle, :domicilio_numero, :domicilio_manzana, :domicilio_piso
  attr_accessible :domicilio_depto, :domicilio_entre_calle_1, :domicilio_entre_calle_2
  attr_accessible :domicilio_barrio_o_paraje, :domicilio_provincia_id, :domicilio_departamento_id
  attr_accessible :domicilio_distrito_id, :domicilio_codigo_postal, :telefono, :efector_id
  attr_accessible :fecha_de_la_novedad, :score_de_riesgo, :alfabetizacion_id, :años_en_el_ultimo_nivel
  attr_accessible :alfabetizacion_de_la_madre_id, :años_en_el_ultimo_nivel_de_la_madre
  attr_accessible :alfabetizacion_del_padre_id, :años_en_el_ultimo_nivel_del_padre
  attr_accessible :alfabetizacion_del_tutor_id, :años_en_el_ultimo_nivel_del_tutor
  attr_accessible :e_mail, :numero_de_celular, :fecha_de_ultima_menstruacion
  attr_accessible :observaciones_generales, :discapacidad

  # Asociaciones
  belongs_to :centro_de_inscripcion
  belongs_to :tipo_de_novedad
  belongs_to :estado_de_la_novedad
  
  # Validaciones
  validates_presence_of :centro_de_inscripcion, :tipo_de_novedad, :clave_de_beneficiario
  validate :validar_completitud

  # Busca las novedades por número de documento
  def self.busqueda_por_documento(doc = nil)

    # Verificar el parámetro
    documento = doc.to_s.strip
    if !documento || documento.blank?
      return nil
    end

    # Buscar el número de documento en cualquiera de los campos de documentos
    # de las novedades cuya resolución está pendiente
    novedades = NovedadDelAfiliado.where("(numero_de_documento = ? OR
      numero_de_documento_de_la_madre = ? OR numero_de_documento_del_padre = ? OR
      numero_de_documento_del_tutor = ?) AND estado_de_la_novedad_id IN (1, 2, 3)",
      documento, documento, documento, documento)

    # Devolver 'nil' si no se encontró el número de documento
    return nil if novedades.size < 1

    return novedades
  end

  # Verifica que los datos estén completos para el tipo de novedad ingresado
  def validar_completitud
    return true
  end
end
