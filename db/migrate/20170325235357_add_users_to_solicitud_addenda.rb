class AddUsersToSolicitudAddenda < ActiveRecord::Migration
  def change
    
    
    add_column :solicitudes_addendas, :user_creator_id, :integer
    add_column :solicitudes_addendas, :user_tecnica_id,:integer
    add_column :solicitudes_addendas, :user_legal_id, :integer
    
     add_index :solicitudes_addendas, :user_creator_id, :name => 'user_creator_id'
  add_index :solicitudes_addendas, :user_tecnica_id, :name => 'user_tecnica_id'
  add_index :solicitudes_addendas, :user_legal_id, :name => 'user_legal_id'
  
    
    
  end
 
  
end
