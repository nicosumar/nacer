class AddExpedienteToConceptoDeFacturacion < ActiveRecord::Migration
  def up
  	add_column :conceptos_de_facturacion, :tipo_de_expediente_id, "int4"
  end
  

  def down
  	 remove_column :conceptos_de_facturacion, :tipo_de_expediente_id
  end
end
