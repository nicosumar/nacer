class AgregarGrupoDeUsuarioParaProcesos < ActiveRecord::Migration
  def up
    ug = UserGroup.new
    ug.user_group_name = "procesos_uad"
    ug.user_group_description = "UAD - Procesos de datos externos"
    ug.save!
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
