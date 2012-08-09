###############################
# TEST FILE FOR RUBYJSON MODULE
###############################

require "./RubyJson"
include Json

require 'date'
require 'time'
require 'securerandom'

class Prob2 < Serializable
  attr_accessor :val, :timeVal, :dateVal, :datetimeVal
end

class Prob < Serializable
  attr_accessor :test1, :test2, :classVar2

  def Calc(a, b)
    a + b
  end
end

class AnotherClass < Serializable
  attr_accessor :arr, :arrObj, :arrHash, :arrArr, :hash, :hashArr, :hashHash, :hashObj
end

class TestObject < Serializable
  attr_accessor :testVal, :val2, :val3
end

class TestClass < Serializable
  attr_accessor :Id, :val1, :val2, :classVar, :pro, :trueVal, :falseVal, :nilVal, :unusedVal, :anotherClass

  def name
    @name
  end

  def name= name
    @name = name
  end

  def SayHello
    print "Hello, World!!!"
  end

  def foo; end

  def bar; end

  def yamlix; end
end



tracer = RubyProvider.new

##############################
# Creating Test Object
##############################

test = TestClass.new
test.Id = "2d931510-d99f-494a-8c67-87feb05e1594"
test.val1 = "Hello,\t my \n dear world. \b How \r do \f you \" do \\ ? /"
test.val2 = 100500
test.name = [1,2,3]

test.classVar = Prob.new
test.classVar.test1 = "InnerClass Var1"
test.classVar.test2 = 9999

test.classVar.classVar2 = Prob2.new
test.classVar.classVar2.val = "3rd level class"
test.classVar.classVar2.timeVal = Time.now
test.classVar.classVar2.dateVal = Date.new(2012,1,1)
test.classVar.classVar2.datetimeVal = DateTime.new(2001,2,3,4,5,6)

test.pro = {"a" => 1, "b" => 2, "c" => 3}
test.trueVal = true
test.falseVal = false
test.nilVal = nil

test.anotherClass = AnotherClass.new
test.anotherClass.arr = ["This", "is", "array!"]
test.anotherClass.arrHash = [{1 => "This", 2 => "is"}, {"a" => "array of", "b" => "hashes"}]
test.anotherClass.arrArr = [[1, 2, 3], [4, 5, 6], ["a", "b", "c"]]
obj1 = TestObject.new
obj2 = TestObject.new
obj3 = TestObject.new
obj1.testVal, obj2.testVal, obj3.testVal = "TestObj1 for Arrays", "TestObj2 for Arrays", "TestObj3 for Arrays"
obj2.val2 = "Another val2"
obj3.val2 = "obj3 val2"
obj3.val3 = "obj3 val3"
test.anotherClass.arrObj = [obj1, obj2, obj3]

test.anotherClass.hash = {1 => "Regular hash"}
test.anotherClass.hashArr = {1=>["hash", "of"], 2=>["arrays"], 3=>true, 4=>false, 5=>nil}
test.anotherClass.hashHash = {1=>{"a"=>"Very", "b"=>"comlicated"}, 2=>"hash", 3=>{"a"=>"of", "z"=>"hashes"}}
hashObj1 = TestObject.new
hashObj2 = TestObject.new
hashObj3 = TestObject.new
hashObj1.testVal = 100500
hashObj2.testVal = "Too Lazy"
hashObj3.testVal = "I must not be Lazy!!"
test.anotherClass.hashObj = {1=>hashObj1, 2=>hashObj2, 3=>hashObj3}


#####################################
# Serializing & Deserializing objects
#####################################
$jsonString = RubyJson.Serialize(test)
puts $jsonString
$object = RubyJson.Deserialize($jsonString)

