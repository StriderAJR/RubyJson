$: << 'D:/Programs/Univeris/Univeris.DLL'
$: << 'D:/Programs/Univeris/FooBoo/bin'

class A
  attr_accessor :val1, :val2
end

a = A.new
a.val1 = 3
a.val2 = "IronRuby rocks!"

require "Foo"
include FooModule

foo = Foo.new
foo.NetVal1 = "Hello"
foo.NetVal2 = 100

#puts foo.class

require "RubyJson"
include Json

include System

foo.GetType().GetProperties().each do |prop|
  puts "###PROP###"
  puts prop.name
  puts prop.property_type
  puts foo.send(prop.name)
end

json = RubyJson.Serialize(foo)
puts json

#jsonString = %q{
#{
#        "__class" : "TestClass",
#        "Id" : "2d931510-d99f-494a-8c67-87feb05e1594",
#        "val1" : "MyTestClass"
#}
#}
#
#obj = RubyJson.DeserializeWithNoRestrictions(jsonString)
#puts obj.val1