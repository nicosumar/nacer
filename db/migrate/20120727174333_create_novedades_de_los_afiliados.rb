class CreateNovedadesDeLosAfiliados < ActiveRecord::Migration
  def change
    create_table :novedades_de_los_afiliados do |t|
      t.references :centro_de_inscripcion, :null => false
      t.references :tipo_de_novedad, :null => false
      t.references :estado_de_la_novedad, :null => false
      t.string :clave_de_beneficiario, :null => false
      t.string :apellido
      t.string :nombre
      t.references :tipo_de_documento
      t.references :clase_de_documento
      t.string :numero_de_documento
      t.references :sexo
      t.references :categoria_de_afiliado
      t.date :fecha_de_nacimiento
      t.integer :pais_de_nacimiento_id
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
      t.date :fecha_de_diagnostico_del_embarazo
      t.integer :semanas_de_embarazo
      t.date :fecha_probable_de_parto
      t.date :fecha_efectiva_de_parto
      t.string :domicilio_calle
      t.string :domicilio_numero
      t.string :domicilio_manzana
      t.string :domicilio_piso
      t.string :domicilio_depto
      t.string :domicilio_entre_calle_1
      t.string :domicilio_entre_calle_2
      t.string :domicilio_barrio_o_paraje
      t.integer :domicilio_provincia_id
      t.integer :domicilio_departamento_id
      t.integer :domicilio_distrito_id
      t.string :domicilio_codigo_postal
      t.string :telefono
      t.references :efector
      t.date :fecha_de_la_novedad, :null => false
      t.string :score_de_riesgo
      t.integer :alfabetizacion_id
      t.integer :años_en_el_ultimo_nivel
      t.integer :alfabetizacion_de_la_madre_id
      t.integer :años_en_el_ultimo_nivel_de_la_madre
      t.integer :alfabetizacion_del_padre_id
      t.integer :años_en_el_ultimo_nivel_del_padre
      t.integer :alfabetizacion_del_tutor_id
      t.integer :años_en_el_ultimo_nivel_del_tutor
      t.string :e_mail
      t.string :numero_de_celular
      t.date :fecha_de_ultima_menstruacion
      t.text :observaciones_generales
      t.references :discapacidad
      t.string :created_by
      t.string :updated_by
      t.timestamps
    end
  end
end
