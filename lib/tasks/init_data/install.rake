namespace :install do
  desc "TODO"
  task :data => :environment do

	Rake::Task['addUserGroup_201704260914:execute'].invoke
	puts "UsersGoups agregados"
	Rake::Task['disable_TiposDeDocumentos_201704271258'].invoke
	puts "Tipos de documentos deshabilitados"
  end
end