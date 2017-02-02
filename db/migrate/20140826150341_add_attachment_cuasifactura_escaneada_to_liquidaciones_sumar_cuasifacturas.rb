class AddAttachmentCuasifacturaEscaneadaToLiquidacionesSumarCuasifacturas < ActiveRecord::Migration
  def self.up
    change_table :liquidaciones_sumar_cuasifacturas do |t|
      t.attachment :cuasifactura_escaneada
    end
  end

  def self.down
    remove_attachment :liquidaciones_sumar_cuasifacturas, :cuasifactura_escaneada
  end
end
