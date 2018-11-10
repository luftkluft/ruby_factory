# frozen_string_literal: true

class Factory
  def self.new(*keys, &block)
    raise ArgumentError, 'Empty initialize' if keys.empty?

    if keys[0].is_a? String
      constant_name = keys.shift
      const_set(constant_name.capitalize, get_class(*keys, &block))
    else
      self.get_class(*keys, &block)
    end
  end

  def self.get_class(*keys, &block)
    Class.new do
      attr_accessor(*keys)
      class_eval(&block) if block_given?

      define_method :initialize do |*keys_data|
        raise ArgumentError, 'Mismatch number of arguments' if keys.count != keys_data.count

        keys.zip(keys_data).each do |arg, value|
          raise NameError, "identifier #{arg} must be constant" unless arg.is_a? Symbol

          send("#{arg}=", value)
        end

        def [](arg)
          return instance_variable_get(instance_variables[arg]) if arg.is_a?(Integer)

          instance_variable_get("@#{arg}")
        end

        def []=(arg, value)
          return instance_variable_set(instance_variables[arg], value) if arg.is_a?(Integer)

          instance_variable_set(:"@#{arg}", value)
        end
      end
    end
  end
end
