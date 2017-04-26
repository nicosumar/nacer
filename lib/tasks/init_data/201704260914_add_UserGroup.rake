namespace :addUserGroup_201704260914 do
  desc "TODO"
  task :execute => :environment do

ActiveRecord::Base.connection.execute "
INSERT INTO user_groups(
id, user_group_name, created_at, updated_at, user_group_description)
VALUES (18, 'gestion_addendas_uad', date('29/03/2017'), date('29/03/2017'), 'UAD - Encargado de Adendas');
"    
  end
end