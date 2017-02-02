class CreatePeriodos < ActiveRecord::Migration
  def change
  	#Esta tabla no esta normalizada. 
  	#La columna periodo es un grupo repetitivo dado que es una descripcion del periodo que corresponde liquidar
  	#Por simplicidad (KISS) y dado que nosotros creamos los periodos (x ahora) pueden armarse queries agrupando por "periodo"
  	#TODO: Quedaria pendiente la normalizacion para evitar errores de tipeo
    create_table :periodos do |t|
      t.string :periodo
      t.date :fecha_cierre
      t.date :fecha_recepcion
      t.references :tipo_periodo
      t.references :concepto_de_facturacion

      t.timestamps
    end
  end
end
