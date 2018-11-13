# frozen_string_literal: true

require_relative 'methods'

class Factory
  def self.new(*keys, &block)
    raise ArgumentError, 'Empty initialize' if keys.empty?

    if keys[0].is_a? String
      const_set(keys.shift.capitalize, get_class(*keys, &block))
    else
      get_class(*keys, &block)
    end
  end

  def self.get_class(*keys, &block)
    Class.new do
      attr_accessor(*keys)
      class_eval(&block) if block_given?

      define_method :initialize do |*keys_data|
        raise ArgumentError, 'Mismatch number of arguments' if keys.count != keys_data.count

        keys.zip(keys_data).each { |arg, value| send("#{arg}=", value) }
      end
      include Methods
    end
  end
end
