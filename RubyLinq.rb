# ##############################################################################################
#
# Copyright (c) Microsoft Corporation.
#
# This source code is subject to terms and conditions of the Apache License, Version 2.0. A
# copy of the license can be found in the License.html file at the root of this distribution. If
# you cannot locate the  Apache License, Version 2.0, please send an email to
# ironruby@microsoft.com. By using this source code in any fashion, you are agreeing to be bound
# by the terms of the Apache License, Version 2.0.
#
# You must not remove this notice, or any other, from this software.
#
# ##############################################################################################

# 101 LINQ Samples in Ruby (see http://msdn.microsoft.com/en-us/vcsharp/aa336746.aspx)

load_assembly 'System.Core'
using_clr_extensions System::Linq

# Linq Helpers

class Object
  def to_seq(type = Object)
    System::Linq::Enumerable.method(:of_type).of(type).call(self.to_a)
  end

  def to_qu(type = Object)
    System::Linq::IOrderedQueryable.method(:of_type).of(type).call(self.to_a)
  end
end

make_pair = lambda { |a,b| [a,b] }
identity = lambda { |a| a }

############
### Data ###
############

Product = Struct.new(:product_name, :category, :units_in_stock, :unit_price)
products = [
    Product["product 1", "foo", 4, 1.3],
    Product["product 2", "bar", 3, 10.0],
    Product["product 3", "baz", 0, 4.0],
    Product["product 4", "foo", 1, 2.5],
]

Order = Struct.new(:id, :total, :order_date)
orders = [
  Order[0,   56.4, 1995],
  Order[1,  100.3, 2001],
  Order[2, 1000.0, 1992],
  Order[3, 1100.4, 2005],
  Order[4,  150.3, 2004],
  Order[5, 1040.0, 1996],
]

Customer = Struct.new(:id, :customer_name, :company_name, :region, :orders)
customers = [
  Customer[0, "customer 1", "company 1", "WA", [orders[0], orders[1], orders[5]]],
  Customer[1, "customer 2", "company 2", "CA", [orders[2], orders[3]]],
  Customer[2, "customer 3", "company 3", "NY", [orders[4]]],
  Customer[3, "customer 4", "company 4", "WA", []],
]

products = products.to_seq
orders = orders.to_seq
customers = customers.to_seq

numbers = [ 5, 4, 1, 3, 9, 8, 6, 7, 2, 0 ].to_seq
digits_array = ["zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]
digits = digits_array.to_seq

lin_products = products.to_qu
lin_products.where(lambda { |p| p.units_in_stock == 0 }).each { |x| puts x.product_name }

###################
### Restriction ###
###################
=begin
puts '-- Where: Simple 1'
numbers.where(lambda { |n| n < 5 }).each { |x| puts x }


puts '-- Where: Simple 2'
products.where(lambda { |p| p.units_in_stock == 0 }).each { |x| puts x.product_name }


puts '-- Where: Simple 3'
products.where(lambda { |p| p.units_in_stock > 0 and p.unit_price > 3.00 }).each { |x| puts x.product_name }


puts '-- Where: Drilldown'
wa_customers = customers.where(lambda {|c| c.region == "WA"})
wa_customers.each do |customer|
  puts "Customer #{customer.id}: #{customer.company_name}"
  customer.orders.each do |order|
    puts "  Order #{order.id}: #{order.order_date}"
  end
end


puts '-- Where: Indexed'
digits.where(lambda { |digit, index| digit.size < index }).each { |x| puts x }
=end