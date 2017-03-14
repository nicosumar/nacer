class CreateMotivosBajasBeneficiarios < ActiveRecord::Migration
  def change
    create_table :motivos_bajas_beneficiarios do |t|
      t.string :nombre

      t.timestamps
    end
  end
end
