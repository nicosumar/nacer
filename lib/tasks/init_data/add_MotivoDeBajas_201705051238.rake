namespace :add_MotivoDeBajas_201705051238 do
  desc "TODO"
  task :execute => :environment do

ActiveRecord::Base.connection.execute "
INSERT INTO motivos_bajas_beneficiarios(
            id, nombre, created_at, updated_at)
    VALUES (12,'Faltan datos Imprescindibles', '2017-05-05', '2017-05-05');
    
INSERT INTO motivos_bajas_beneficiarios(
            id, nombre, created_at, updated_at)
    VALUES (51,'Documento de beneficiario no valido', '2017-05-05', '2017-05-05');
    
INSERT INTO motivos_bajas_beneficiarios(
            id, nombre, created_at, updated_at)
    VALUES (81,'Beneficiario duplicado x Tipo y Nro. doc. benef.: ', '2017-05-05', '2017-05-05');
    
INSERT INTO motivos_bajas_beneficiarios(
            id, nombre, created_at, updated_at)
    VALUES (91,'Fallecimiento', '2017-05-05', '2017-05-05');
"    
  end
end