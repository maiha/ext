# require 'config/boot'
# require 'active_support'
# $:.unshift(RAILS_ROOT + "/lib")

require 'config/environment'

class String
  def comparable
    gsub(/\s+/,'').strip
  end
end


# sort keys of JSON:hash for testing

module ActiveSupport
  module JSON
    module Encoders
      define_encoder Hash do |hash|
        returning result = '{' do
          keys = hash.keys.sort{|a,b| b.to_s <=> a.to_s}
          result << keys.map do |key|
            value = hash[key]
            key = ActiveSupport::JSON::Variable.new(key.to_s) if
              ActiveSupport::JSON.can_unquote_identifier?(key)
            "#{key.to_json}: #{value.to_json}"
          end * ', '
          result << '}'
        end
      end
    end
  end
end


class ARMock
  class << self
    def table_name() "id" end

    def columns
      [
       new_column("id"   , nil, "integer"),
       new_column("name" , nil, "string"),
       new_column("time" , nil, "date"),
      ]
    end

    def new_column(*args)
      # def initialize(name, default, sql_type = nil, null = true)
      ActiveRecord::ConnectionAdapters::Column.new(*args)
    end
  end
end


