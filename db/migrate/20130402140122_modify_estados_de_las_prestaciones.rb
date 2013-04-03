# -*- encoding : utf-8 -*-
class ModifyEstadosDeLasPrestaciones < ActiveRecord::Migration

  def change
    # Añadir las columnas necesarias
    add_column :estados_de_las_prestaciones, :codigo, :string
    add_column :estados_de_las_prestaciones, :pendiente, :boolean, :default => false
    add_column :estados_de_las_prestaciones, :indexable, :boolean, :default => false

    # Actualizar e insertar los datos faltantes
    EstadoDeLaPrestacion.find(1).update_attributes({:nombre => 'Registrada, pero incompleta', :codigo => 'I', :pendiente => true, :indexable => true})
    EstadoDeLaPrestacion.find(2).update_attributes({:nombre => 'Registrada, pero faltan atributos', :codigo => 'F', :pendiente => true, :indexable => true})
    EstadoDeLaPrestacion.find(3).update_attributes({:nombre => 'Registrada, aún no se ha facturado', :codigo => 'R', :pendiente => true, :indexable => true})
    EstadoDeLaPrestacion.find(4).update_attributes({:nombre => 'Facturada, en proceso de liquidación', :codigo => 'P', :pendiente => false, :indexable => true})
    EstadoDeLaPrestacion.create({:nombre => 'Aprobada y liquidada', :codigo => 'L', :pendiente => false, :indexable => false})
    EstadoDeLaPrestacion.create({:nombre => 'Rechazada por la UGSP', :codigo => 'Z', :pendiente => false, :indexable => false})
    EstadoDeLaPrestacion.create({:nombre => 'Debitada por auditoría interna', :codigo => 'D', :pendiente => false, :indexable => false})
    EstadoDeLaPrestacion.create({:nombre => 'Debitada por auditoría externa', :codigo => 'X', :pendiente => false, :indexable => false})
    EstadoDeLaPrestacion.create({:nombre => 'Anulada por el usuario', :codigo => 'U', :pendiente => false, :indexable => false})
    EstadoDeLaPrestacion.create({:nombre => 'Anulada por el sistema', :codigo => 'S', :pendiente => false, :indexable => false})
  end

end
