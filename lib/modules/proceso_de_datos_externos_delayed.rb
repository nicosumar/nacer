# -*- encoding : utf-8 -*-
module Delayed
  class ProcesoDeDatosExternosWrapper
    attr_accessor :codigo_de_esquema, :proceso_id

    def initialize(codigo_de_esquema, proceso_id)
      @codigo_de_esquema = codigo_de_esquema
      @proceso_id = proceso_id
    end

    def perform
      ActiveRecord::Base.connection.schema_search_path = "uad_#{@codigo_de_esquema}, public"
      ProcesoDeDatosExternos.find(@proceso_id).procesar
    end
  end
end
