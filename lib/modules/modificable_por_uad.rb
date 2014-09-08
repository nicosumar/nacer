# -*- encoding : utf-8 -*-
require 'active_support/core_ext/class/attribute'

module ActiveRecord
  module AtributosModificablesPorUad

    def self.included(mod)
      class_attribute :_atributo_modificable, :instance_writer => false
      self._atributo_modificable = []
    end

    module ClassMethods

      def atributo_modificable(*atributos)
        self._atributo_modificable = Set.new(atributos.map(&:to_s)) + (self._atributo_modificable || [])
      end

      def atributos_modificables
        self._atributo_modificable
      end

    end

  end
end
