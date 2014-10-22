# -*- encoding : utf-8 -*-
ugsp = OrganismoGubernamental.create(
  { #:id => 1,
    nombre: 'Plan Sumar Mendoza',
    domicilio: 'Santa Cruz 350',
    provincia: Provincia.find(9), # Mendoza
    departamento: Departamento.find(9), # Capital
    distrito: Distrito.find(11), # 3ª Sección
    codigo_postal: '5500',
    telefonos: '4247020',
    email: 'plannacer-salud@mendoza.gov.ar'
  }, :without_protection => true)

e = Entidad.new
e.entidad = ugsp
e.save

Efector.all.each do |ef|
  Entidad.create({entidad: ef}, :without_protection => true)
end