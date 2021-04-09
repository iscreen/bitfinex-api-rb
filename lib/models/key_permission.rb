require_relative './model'

module Bitfinex
  module Models
    class KeyPermission < Model
      BOOL_FIELDS = ['read', 'write']
      FIELDS = {
        :scope => 0,
        :read => 1,
        :write => 2
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
