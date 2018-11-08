# RubyGarage Factory task

Factory class is a simplified Struct class implementation.

Enter 'ruby lib/index.rb' to run.

# Default example:

```ruby

Customer = Factory.new(:name, :address, :zip)

joe = Customer.new('Joe Smith', '123 Maple, Anytown NC', 12_345)

p joe.name     # => "Joe Smith"
p joe['name']  # => "Joe Smith"
p joe[:name]   # => "Joe Smith"
p joe[0]       # => "Joe Smith"

Customer2 = Factory.new(:name, :address) do
  def greeting
    "Hello #{name}!"
  end
end

p Customer2.new('Dave', '123 Main').greeting # => "Hello Dave!"
```
