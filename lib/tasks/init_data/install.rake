namespace :install do
  desc "TODO"
  task :data => :environment do

	Rake::Task['addUserGroup_201704260914:execute'].invoke
	puts "Instalación Finalizada"
  end
end