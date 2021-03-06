require_relative './model'

module Bitfinex
  module Models
    class Currency < Model
      BOOL_FIELDS = []
      FIELDS = {
        :id => 0,
        :name => 1,
        :pool => 2,
        :explorer => 3
      }

      FIELDS.each do |key, index|
        attr_accessor key
      end

      def initialize (data)
        super(data, FIELDS, BOOL_FIELDS)
      end

      def self.unserialize (data)
        return Model.unserialize(data, FIELDS, BOOL_FIELDS)
      end
    end
  end
end
