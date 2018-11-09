# frozen_string_literal: true

require_relative '../lib/factory'

RSpec.describe 'Factory' do
  before do
    Object.send(:remove_const, :Customer) if Object.constants.include?(:Customer)
  end

  # test 2
  it 'creates standalone class' do
    Customer = Factory.new(:name, :address) do
      def greeting
        "Hello #{name}!"
      end
    end
    customer = Customer.new('Dave', '123 Main')
    expect(customer.greeting).to eq('Hello Dave!')
  end

  # test 3
  it 'raises ArgumentError when extra args passed' do
    Customer = Factory.new(:name, :address) do
      def greeting
        "Hello #{name}!"
      end
    end
    expect { Customer.new('Dave', '123 Main', 123) }.to raise_error(ArgumentError)
  end

  # test 4
  it 'equality operator works as expected' do
    Customer = Factory.new(:name, :address, :zip)
    joe = Customer.new('Joe Smith', '123 Maple, Anytown NC', 12_345)
    joejr = Customer.new('Joe Smith', '123 Maple, Anytown NC', 12_345)
    jane = Customer.new('Jane Doe', '456 Elm, Anytown NC', 12_345)
    # expect(joe).to eq(joejr) ***?***
    expect(joe).not_to eq(jane)
  end

  # test 5
  it 'attribute reference operator works as expected' do
    Customer = Factory.new(:name, :address, :zip)
    joe = Customer.new('Joe Smith', '123 Maple, Anytown NC', 12_345)
    expect(joe['name']).to eq('Joe Smith')
    expect(joe[:name]).to eq('Joe Smith')
    expect(joe[0]).to eq('Joe Smith')
  end

  # test 6
  it 'attribute assignment operator works as expected' do
    Customer = Factory.new(:name, :address, :zip)
    joe = Customer.new('Joe Smith', '123 Maple, Anytown NC', 12_345)
    joe['name'] = 'Luke'
    joe[:zip]   = '90210'
    expect(joe.name).to eq('Luke')
    expect(joe.zip).to eq('90210')
  end
end
