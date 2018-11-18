# frozen_string_literal: true

module Validator
  include Errors

  def check_for_match_argument_count(first, other)
    raise ArgumentError, 'Mismatch number of arguments' if first.count != other.count
  end

  def chech_for_symbol(*symbol)
    symbol.each { |element| raise WrongSymbolError unless element.is_a?(Symbol) }
  end

  def check_for_emptiness(string)
    raise EmptyStringError if string.empty?
  end
end
