# frozen_string_literal: true

require_relative 'autoload'

Customer = Factory.new(:name, :address, :zip)

joe = Customer.new('Joe Smith', '123 Maple, Anytown NC', 12_345)

p joe.name
p joe['name']
p joe[:name]
p joe[0]

Customer2 = Factory.new(:name, :address) do
  def greeting
    "Hello #{name}!"
  end
end

p Customer2.new('Dave', '123 Main').greeting

Customer3 = Factory.new(:name, :address, :zip)

joe = Customer3.new('Joe Smith', '123 Maple, Anytown NC', 12_345)

joe['name'] = 'Luke'
joe[:zip]   = '90210'
p joe.name
p joe.zip
