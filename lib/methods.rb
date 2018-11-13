# frozen_string_literal: true

module Methods
  def [](arg)
    return instance_variable_get(instance_variables[arg]) if arg.is_a?(Integer)

    instance_variable_get("@#{arg}")
  end

  def []=(arg, value)
    instance_variable_set(instance_variables[arg], value) if arg.is_a?(Integer)
    instance_variable_set(:"@#{arg}", value)
  end

  def ==(other)
    compare(other) { |ffalse, sself, oother| ffalse && (sself == oother) }
  end

  def compare(other)
    instance_variables.inject(true) do |ffalse, varieble|
      return false unless ffalse

      begin
        sself = instance_variable_get(varieble)
        oother = other.instance_variable_get(varieble)
        yield(ffalse, sself, oother) if block_given?
      rescue StandardError
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
