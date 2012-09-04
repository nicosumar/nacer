class NovedadDelAfiliado < ActiveRecord::Base
  # Los atributos siguientes pueden asignarse en forma masiva
  attr_accessible :apellido, :nombre, :clase_de_documento_id, :tipo_de_documento_id, :numero_de_documento
  attr_accessible :numero_de_celular, :e_mail, :categoria_de_afiliado_id, :sexo_id, :fecha_de_nacimiento
  attr_accessible :pais_de_nacimiento_id, :se_declara_indigena, :lengua_originaria_id, :tribu_originaria_id
  attr_accessible :alfabetizacion_del_beneficiario_id, :alfab_beneficiario_años_ultimo_nivel
  attr_accessible :domicilio_calle, :domicilio_numero, :domicilio_piso, :domicilio_depto, :domicilio_manzana
  attr_accessible :domicilio_entre_calle_1, :domicilio_entre_calle_2, :telefono, :otro_telefono
  attr_accessible :domicilio_departamento_id, :domicilio_distrito_id, :domicilio_barrio_o_paraje
  attr_accessible :domicilio_codigo_postal, :observaciones, :lugar_de_atencion_habitual_id
  attr_accessible :apellido_de_la_madre, :nombre_de_la_madre, :tipo_de_documento_de_la_madre_id
  attr_accessible :numero_de_documento_de_la_madre, :alfabetizacion_de_la_madre_id, :alfab_madre_años_ultimo_nivel
  attr_accessible :apellido_del_padre, :nombre_del_padre, :tipo_de_documento_del_padre_id
  attr_accessible :numero_de_documento_del_padre, :alfabetizacion_del_padre_id, :alfab_padre_años_ultimo_nivel
  attr_accessible :apellido_del_tutor, :nombre_del_tutor, :tipo_de_documento_del_tutor_id
  attr_accessible :numero_de_documento_del_tutor, :alfabetizacion_del_tutor_id, :alfab_tutor_años_ultimo_nivel
  attr_accessible :fecha_de_la_ultima_menstruacion, :fecha_de_diagnostico_del_embarazo, :semanas_de_embarazo
  attr_accessible :fecha_probable_de_parto, :fecha_efectiva_de_parto, :score_de_riesgo, :discapacidad_id
  attr_accessible :nombre_del_agente_inscriptor, :observaciones_generales

  # La clave de beneficiario sólo puede registrarse al grabar la novedad
  attr_readonly :clave_de_beneficiario

  # Asociaciones
  belongs_to :clase_de_documento
  belongs_to :tipo_de_documento
  #belongs_to :categoria_de_afiliado_id     #-- OBSOLETO
  belongs_to :sexo
  belongs_to :pais_de_nacimiento, :class_name => "Pais"
  belongs_to :lengua_originaria
  belongs_to :tribu_originaria
  belongs_to :alfabetizacion_del_beneficiario, :class_name => "NivelDeInstruccion"
  belongs_to :domicilio_departamento, :class_name => "Departamento"
  belongs_to :domicilio_distrito, :class_name => "Distrito"
  belongs_to :lugar_de_atencion_habitual, :class_name => "Efector"
  belongs_to :tipo_de_documento_de_la_madre, :class_name => "TipoDeDocumento"
  belongs_to :alfabetizacion_de_la_madre, :class_name => "NivelDeInstruccion"
  belongs_to :tipo_de_documento_del_padre, :class_name => "TipoDeDocumento"
  belongs_to :alfabetizacion_del_padre, :class_name => "NivelDeInstruccion"
  belongs_to :tipo_de_documento_del_tutor, :class_name => "TipoDeDocumento"
  belongs_to :alfabetizacion_del_tutor, :class_name => "NivelDeInstruccion"
  belongs_to :discapacidad
  
  # Validaciones
  validates_presence_of :tipo_de_novedad_id, :estado_de_la_novedad_id, :clave_de_beneficiario
  validates_presence_of :centro_de_inscripcion_id
  validate :validar_completitud

  # copiar_atributos_del_afiliado
  # Copia los valores de los atributos del afiliado a esta novedad
  def copiar_atributos_del_afiliado(afiliado)
    return  if (!afiliado || !afiliado.kind_of?(Afiliado))

    # Copiar todos los atributos que se pueden asignar masivamente
    self.attributes = afiliado.attributes

    # Definir los atributos que no se pueden asignar masivamente
    self.clave_de_beneficiario = afiliado.clave_de_beneficiario
    self.fecha_de_inscripcion = afiliado.fecha_de_inscripcion
    return true
  end

  # Verifica que los datos estén completos para el tipo de novedad ingresado
  def validar_completitud
    return true
  end
end
