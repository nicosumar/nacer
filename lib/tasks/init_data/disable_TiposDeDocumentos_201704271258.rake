namespace :disable_TiposDeDocumentos_201704271258 do
  desc "TODO"
  task :execute => :environment do

ActiveRecord::Base.connection.execute "
	UPDATE tipos_de_documentos SET activo= FALSE WHERE codigo in ('LE','LC','CI','PAS','OTRO')
"    
  end
end