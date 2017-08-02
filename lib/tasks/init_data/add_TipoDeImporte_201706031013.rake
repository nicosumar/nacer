namespace :add_TipoDeImporte_201706031013 do
  desc "TODO"
  task :execute => :environment do

ActiveRecord::Base.connection.execute "
	INSERT INTO tipos_de_importe(
            id, nombre, created_at, updated_at)
    VALUES (1,'Servicios', '2017-06-03', '2017-06-03');
    
	INSERT INTO tipos_de_importe(
            id, nombre, created_at, updated_at)
    VALUES (2,'Obras', '2017-06-03', '2017-06-03);

    INSERT INTO tipos_de_importe(
            id, nombre, created_at, updated_at)
    VALUES (3,'Bienes Corrientes', '2017-06-03', '2017-05-05');

    INSERT INTO tipos_de_importe(
            id, nombre, created_at, updated_at)
    VALUES (4,'Bienes de Capital, '2017-06-03', '2017-06-03');
"    
  end
end