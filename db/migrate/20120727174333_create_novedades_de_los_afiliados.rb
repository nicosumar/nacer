class CreateNovedadesDeLosAfiliados < ActiveRecord::Migration
  def change
    create_table :novedades_de_los_afiliados do |t|

      # Tipo y estado de la novedad
      t.references :tipo_de_novedad, :null => false
      t.references :estado_de_la_novedad, :null => false

      # Identificadores
      t.string :clave_de_beneficiario, :null => false, :unique => true

      # Datos personales
      t.string :apellido
      t.string :nombre
      t.references :clase_de_documento
      t.references :tipo_de_documento
      t.string :numero_de_documento
      t.string :numero_de_celular
      t.string :e_mail

      # Mantenemos la categoría de afiliado por razones de compatibilidad
      t.references :categoria_de_afiliado

      # Datos de nacimiento, sexo, origen y estudios
      t.references :sexo
      t.date :fecha_de_nacimiento
      t.integer :pais_de_nacimiento_id
      t.boolean :se_declara_indigena
      t.references :lengua_originaria
      t.references :tribu_originaria
      t.integer :alfabetizacion_del_beneficiario_id
      t.integer :alfab_beneficiario_años_ultimo_nivel

      # Datos de domicilio
      t.string :domicilio_calle
      t.string :domicilio_numero
      t.string :domicilio_piso
      t.string :domicilio_depto
      t.string :domicilio_manzana
      t.string :domicilio_entre_calle_1
      t.string :domicilio_entre_calle_2
      t.string :telefono
      t.string :otro_telefono
      t.integer :domicilio_departamento_id
      t.integer :domicilio_distrito_id
      t.string :domicilio_barrio_o_paraje
      t.string :domicilio_codigo_postal
      t.text :observaciones

      # Lugar de atención habitual
      t.integer :lugar_de_atencion_habitual_id

      # Datos del adulto responsable del menor (para menores)
      t.boolean :es_menor
      t.string :apellido_de_la_madre
      t.string :nombre_de_la_madre
      t.integer :tipo_de_documento_de_la_madre_id
      t.string :numero_de_documento_de_la_madre
      t.integer :alfabetizacion_de_la_madre_id
      t.integer :alfab_madre_años_ultimo_nivel
      t.string :apellido_del_padre
      t.string :nombre_del_padre
      t.integer :tipo_de_documento_del_padre_id
      t.string :numero_de_documento_del_padre
      t.integer :alfabetizacion_del_padre_id
      t.integer :alfab_padre_años_ultimo_nivel
      t.string :apellido_del_tutor
      t.string :nombre_del_tutor
      t.integer :tipo_de_documento_del_tutor_id
      t.string :numero_de_documento_del_tutor
      t.integer :alfabetizacion_del_tutor_id
      t.integer :alfab_tutor_años_ultimo_nivel

      # Datos del embarazo y parto (para embarazadas)
      t.boolean :esta_embarazada
      t.date :fecha_de_la_ultima_menstruacion
      t.date :fecha_de_diagnostico_del_embarazo
      t.integer :semanas_de_embarazo
      t.date :fecha_probable_de_parto
      t.date :fecha_efectiva_de_parto  # Dato mantenido por compatibilidad

      # Score de riesgo cardiovascular del Programa Remediar+Redes
      t.integer :score_de_riesgo

      # Discapacidad
      t.references :discapacidad

      # Fecha y centro inscriptor
      t.date :fecha_de_la_novedad
      t.references :centro_de_inscripcion
      t.string :nombre_del_agente_inscriptor

      # Observaciones generales
      t.text :observaciones_generales

      # Datos relacionados con la carga del registro
      t.string :created_by
      t.string :updated_by
      t.timestamps
    end
  end
end
