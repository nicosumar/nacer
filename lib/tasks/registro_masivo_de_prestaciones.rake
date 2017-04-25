namespace :registro_masivo_de_prestaciones do
  desc "TODO"
  task :registrar_prestaciones, [:file_name, :uad_id, :efector_id] => :environment do |task, args|
	  file_name = args[:file_name]
	  uad_id = args[:uad_id]
	  efector_id = args[:efector_id]

	  load 'lib/tasks/registro_masivo_de_prestaciones_v2.rb'
	  registro = RegistroMasivoDePrestaciones2.new
	  registro = reg.procesar("#{file_name}",UnidadDeAltaDeDatos.find(uad_id),Efector.find(efector_id))

  end
end

