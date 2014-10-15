# -*- encoding : utf-8 -*-
module Delayed
  # Clase definida para poder llamar a un método de una instancia en forma asíncrona mediante DelayedJob, cuando
  # en la base de datos reside en un esquema (schema) distinto del 'public'.
  class MultitenantPerformableMethod
    attr_accessor :esquema, :modelo, :metodo, :id_de_instancia

    def initialize(esquema, modelo, metodo, id_de_instancia)
      if esquema.blank?
        raise ArgumentError, "El parámetro esquema es obligatorio."
      else
        @esquema = esquema
      end

      if !modelo.superclass == ActiveRecord::Base
        raise ArgumentError, "El modelo debe ser una clase derivada de ActiveRecord::Base"
      else
        @modelo = modelo
      end

      instancia = modelo.find(id_de_instancia)

      if !instancia.respond_to?(metodo)
        raise ArgumentError, "La instancia del modelo #{modelo.to_s} no tiene un método #{metodo.to_s}."
      else
        @id_de_instancia = id_de_instancia
        @metodo = metodo
      end
    end

    def perform
      ActiveRecord::Base.connection.schema_search_path = "#{@esquema}, public"
      instancia = @modelo.find(@id_de_instancia)
      instancia.send(@metodo)
    end
  end
end
