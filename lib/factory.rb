# frozen_string_literal: true

class Factory
  def self.new(*keys, &block)
    raise ArgumentError, 'Empty initialize' if keys.empty?

    if keys[0].is_a? String
      constant_name = keys.shift
      const_set(constant_name.capitalize, get_class(*keys, &block))
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

        keys.zip(keys_data).each do |arg, value|
          raise NameError, "identifier #{arg} must be constant" unless arg.is_a?(Symbol)

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

        def ==(other)
          compare(other) { |_false, _self, _other| _false && (_self == _other)}
        end

        def compare(other)
          return true if self.object_id == other.object_id
          self.instance_variables.inject(true) do |_false, varieble|
            return false unless _false
            begin
              _self = self.instance_variable_get(varieble)
              _other = other.instance_variable_get(varieble)
              yield(_false, _self, _other) if block_given?
            rescue Exception => e
              puts "Compare error: #{e.message}"
              false
            end
          end
        end

        def dig(*args)
          to_h.dig(*args)
        end

        def to_h
          Hash[instance_variables.map do |name|
              [name.to_s.delete('@').to_sym,
               instance_variable_get(name)]
          end]
        end

        def each(&value)
          to_a.each(&value)
        end

        def to_a
          instance_variables.map { |varieble| instance_variable_get(varieble) }
        end

        def each_pair(&name_value)
          to_h.each_pair(&name_value)
        end

        def length
          to_a.size
        end

        def size
          to_a.size
        end

        def members
          instance_variables.map { |member| member.to_s.delete('@').to_sym }
        end

        def select(&member_value)
          to_a.select(&member_value)
        end

        def values_at(*indexes)
          indexes.map do |index|
            raise IndexError unless instance_variables[index]
            to_a[index]
          end
        end
      end
    end
  end
end
