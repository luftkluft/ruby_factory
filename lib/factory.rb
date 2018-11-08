# frozen_string_literal: true

class Factory
  def self.new(*keys, &block)
    raise ArgumentError, 'Wrong number of arguments (0 for 1+)' if keys.empty?

    Class.new do
      attr_accessor(*keys)
      class_eval(&block) if block_given?

      define_method :initialize do |*keys_data|
        raise ArgumentError, 'Wrong number of arguments (the number of arguments does not match)' if keys.count != keys_data.count
        keys.zip(keys_data).each do |arg, value|
          unless arg.is_a? Symbol
            raise NameError, "identifier #{arg} must be constant"
          end

          send("#{arg}=", value)
        end

        def [](arg)
          arg.is_a?(Integer) ? instance_variable_get(instance_variables[arg]) : instance_variable_get("@#{arg}")
        end
      end
    end
  end
end
