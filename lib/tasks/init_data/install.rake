namespace :install do
  desc "TODO"
  task :data => :environment do

	Rake::Task['add_UserGroup_201704260914:execute'].invoke
	puts "UsersGoups agregados"
	Rake::Task['disable_TiposDeDocumentos_201704271258:execute'].invoke
	puts "Tipos de documentos deshabilitados"
	Rake::Task['add_MotivoDeBajas_201705051238:execute'].invoke
	puts "Motivos de bajas agregados"

  end
end