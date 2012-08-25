class RecreateAfiliados < ActiveRecord::Migration
  def change
    # Eliminamos la tabla anterior
    drop_table :afiliados

    # Creamos la tabla con la nueva estructura
    create_table :afiliados, :id => false do |t|
      t.integer :afiliado_id, :null => false, :unique => true
      t.string :clave_de_beneficiario, :null => false, :unique => true
      t.string :apellido
      t.string :nombre
      t.references :tipo_de_documento
      t.references :clase_de_documento
      t.string :numero_de_documento
      t.references :sexo_id
      t.references :categoria_de_afiliado
      t.date :fecha_de_nacimiento
      t.integer :pais_de_nacimiento_id
      t.integer :provincia_de_nacimiento_id
      t.integer :departamento_de_nacimiento_id
      t.boolean :se_declara_indigena
      t.references :lengua_originaria
      t.references :tribu_originaria
      t.integer :tipo_de_documento_de_la_madre_id
      t.string :numero_de_documento_de_la_madre
      t.string :apellido_de_la_madre
      t.string :nombre_de_la_madre
      t.integer :tipo_de_documento_del_padre_id
      t.string :numero_de_documento_del_padre
      t.string :apellido_del_padre
      t.string :nombre_del_padre
      t.integer :tipo_de_documento_del_tutor_id
      t.string :numero_de_documento_del_tutor
      t.string :apellido_del_tutor
      t.string :nombre_del_tutor
      t.date :fecha_de_inscripcion
      t.date :fecha_de_diagnostico_del_embarazo
      t.integer :semanas_de_embarazo
      t.date :fecha_probable_de_parto
      t.date :fecha_efectiva_de_parto
      t.string :activo
      t.string :domicilio_calle
      t.string :domicilio_numero
      t.string :domicilio_manzana
      t.string :domicilio_piso
      t.string :domicilio_depto
      t.string :domicilio_entre_calle_1
      t.string :domicilio_entre_calle_2
      t.string :domicilio_barrio_o_paraje
      t.string :domicilio_municipio
      t.string :domicilio_departamento_o_partido
      t.string :domicilio_localidad
      t.string :domicilio_provincia
      t.string :domicilio_codigo_postal
      t.string :telefono
      t.string :codigo_uad
      t.string :codigo_ci_uad
      t.integer :motivo_de_la_baja_id
      t.string :mensaje_de_la_baja
      t.integer :proceso_de_baja_automatica_id
      t.datetime :fecha_y_hora_de_carga
      t.string :usuario_que_carga
      t.string :cuie_del_efector_asignado
      t.string :cuie_del_lugar_de_atencion_habitual
      t.string :clave_del_benef_que_provoca_baja
      t.string :usuario_de_creacion
      t.date :fecha_de_creacion
      t.integer :persona_id
      t.integer :score_de_riesgo
      t.string :alfabetizacion
      t.integer :alfabetizacion_anios_ultimo_nivel
      t.string :alfabetizacion_de_la_madre
      t.integer :alfab_madre_anios_ultimo_nivel
      t.string :alfabetizacion_del_padre
      t.integer :alfab_padre_anios_ultimo_nivel
      t.string :alfabetizacion_del_tutor
      t.integer :alfab_tutor_anios_ultimo_nivel
      t.string :e_mail
      t.string :numero_de_celular
      t.date :fecha_de_ultima_menstruacion
      t.string :observaciones_generales
      t.string :discapacidad
    end
  end
end
