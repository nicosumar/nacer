# -*- encoding : utf-8 -*-

module Paperclip

  class DatosExternos < Processor

    attr_accessor :tabla

    def initialize(file, options = {}, attachment = nil)
      super

      @file = file
      @tipo_de_proceso = options[:tipo_de_proceso]
    end

  end

end
