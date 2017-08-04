class AddDefaultFalseEliminadaPrestaciones < ActiveRecord::Migration
  
  def up
    
    execute "

      UPDATE prestaciones
      SET eliminada = false
      WHERE eliminada is null;

      ALTER TABLE ONLY prestaciones ALTER COLUMN eliminada SET DEFAULT false;
        
      "

  end

end
      
