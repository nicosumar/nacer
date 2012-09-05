class RecreateAfiliados < ActiveRecord::Migration
  def change
    # Eliminamos la tabla anterior
    drop_table :afiliados

    # Creamos la tabla con la nueva estructura
    create_table :afiliados, :id => false do |t|

      # Identificadores
      t.integer :afiliado_id, :null => false
      t.string :clave_de_beneficiario, :null => false

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

      # Datos de residencia, vías de comunicación y lugar habitual de atención
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

      # Lugar de atención habitual
      t.integer :lugar_de_atencion_habitual_id

      # Datos del adulto responsable del menor (para menores de 15 años)
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
      t.date :fecha_de_inscripcion
      t.references :centro_de_inscripcion

      # Observaciones generales
      t.text :observaciones_generales

      # Estado de la inscripción al programa
      t.boolean :activo
      t.integer :motivo_de_la_baja_id
      t.string :mensaje_de_la_baja

      # Datos relacionados con la carga del registro
      t.datetime :fecha_y_hora_de_carga
      t.string :usuario_que_carga
    end

    add_index(:afiliados, :afiliado_id, :unique => true)
    add_index(:afiliados, :clave_de_beneficiario, :unique => true)

  end
end
