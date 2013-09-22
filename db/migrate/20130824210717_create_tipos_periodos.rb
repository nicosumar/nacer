class CreateTiposPeriodos < ActiveRecord::Migration
  def up
    create_table :tipos_periodos do |t|
      t.column :tipo, "char(1)"
      t.string :descripcion

      t.timestamps
    end

    TipoPeriodo.create! { 
    	tipo: 'P', 
    	descripcion: 'Periodo' 
    }

    TipoPeriodo.create! { 
    	tipo: 'R', 
    	descripcion: 'Retroactivo' 
    }

  end

  def down
  	drop_table :tipos_periodos
  end
end
