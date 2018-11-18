# frozen_string_literal: true

class Factory
  class << self
    include Validator

    def new(*keys, &block)
      check_for_emptiness(keys)
      if keys.first.is_a? String
        const_set(keys.shift.capitalize, build_class(*keys, &block))
      else
        build_class(*keys, &block)
      end
    end

    def build_class(*keys, &block)
      Class.new do
        attr_accessor(*keys)
        include Validator

        define_method :initialize do |*keys_value|
          chech_for_symbol(*keys)
          check_for_match_argument_count(keys, keys_value)
          keys.zip(keys_value).each { |key, value| public_send("#{key}=", value) }
        end

        def [](arg)
          return instance_variable_get(instance_variables[arg]) if arg.is_a?(Integer)

          instance_variable_get("@#{arg}")
        end

        def []=(arg, value)
          arg_value = arg.is_a?(Integer) ? instance_variables[arg] : :"@#{arg}"
          instance_variable_set(arg_value, value)
        end

        def ==(other)
          compare(other) do |result_of_compare, variable_of_first_object, variable_of_other|
            result_of_compare && (variable_of_first_object == variable_of_other)
          end
        end

        def dig(*path)
          path.inject(self) do |key, value|
            return nil if key[value].nil?

            key[value]
          end
        end

        def to_h
          instance_variables.map { |variable| variable.to_s.delete('@').to_sym }.zip(to_a).to_h
        end

        def each(&value)
          to_a.each(&value)
        end

        def to_a
          instance_variables.map { |variable| instance_variable_get(variable) }
        end

        def each_pair(&name_value)
          to_h.each_pair(&name_value)
        end

        def length
          to_a.size
        end

        def members
          to_h.keys
        end

        def select(&member_value)
          to_a.select(&member_value)
        end

        def values_at(*indexes)
          indexes.map { |index| to_a[index] }
        end

        alias_method :size, :length
        alias_method :eql?, :==
        alias_method :values, :to_a
        class_eval(&block) if block_given?

        private

        def compare(other)
          instance_variables.inject(true) do |result_of_compare, variable|
            return false unless result_of_compare

            begin
              variable_of_first_object = instance_variable_get(variable)
              variable_of_other = other.instance_variable_get(variable)
              yield(result_of_compare, variable_of_first_object, variable_of_other) if block_given?
            rescue StandardError
              false
            end
          end
        end
      end
    end
  end
end
