#
# Test file for RubyAutopsist Module
#

require "./RubyAutopsist"
include Autopsist

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

class RubyProvider
  def GetHash
    $hashString
  end

  def GetJson
    $jsonString
  end

  def GetClassName
    $className
  end
end
tracer = RubyProvider.new

test = TestClass.new
test.Id = "2d931510-d99f-494a-8c67-87feb05e1594"
test.val1 = "MyTestClass"
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



#$jsonString = RubyAutopsist.Serialize(test)
#$className = test.class
#
#print tracer.GetJson
#puts


#hash = RubyAutopsist.Deserialize($jsonNET)
#arrayHash = hash["arrArr"]
#str = arrayHash[2][1]
#print str

#print RubyAutopsist.Deserialize($jsonNET)

$jsonNET = %q{
{
        "Id" : "2d",
        "val1" : "MyTestClass",
        "classVar" : {
                "__id" : "bc",
                "__className" : "Prob",
                "test2" : 9999,
                "classVar2" : {
                        "__id" : "d3",
                        "dateVal" : 1325376000000+0000,
                        "val" : "3rd level class",
                        "datetimeVal" : 981173106000+0000,
                        "timeVal" : 1343711309000+0600,
                        "__className" : "Prob2"
                },
                "test1" : "InnerClass Var1"
        },
        "val2" : 100500,
        "trueVal" : true,
        "__className" : "TestClass",
        "pro" : {
                "__id" : "a1",
                "c" : 3,
                "b" : 2,
                "a" : 1
        },
        "name" : [1,2,3],
        "anotherClass" : {
                "__id" : "19",
                "__className" : "AnotherClass",
                "arrObj" : [
                        {
                                "__id" : "8e",

                                "testVal" : "TestObj1 for Arrays",
                                "__className" : "TestObject"
                        },
                        {
                                "__id" : "07",

                                "__className" : "TestObject",
                                "testVal" : "TestObj2 for Arrays",
                                "val2" : "Another val2"
                        },
                        {
                                "__id" : "a4",

                                "val3" : "obj3 val3",
                                "__className" : "TestObject",
                                "testVal" : "TestObj3 for Arrays",
                                "val2" : "obj3 val2"
                        }
                ],
                "arr" : ["This","is","array!"],
                "hash" : {
                        "__id" : "0d",
                        "1" : "Regular hash"
                },
                "hashObj" : {
                        "__id" : "a8",
                        "1" : {
                                "__id" : "d8",

                                "__className" : "TestObject",
                                "testVal" : 100500
                        },
                        "3" : {
                                "__id" : "4d",

                                "testVal" : "I must not be Lazy!!",
                                "__className" : "TestObject"
                        },
                        "2" : {
                                "__id" : "25",

                                "testVal" : "Too Lazy",
                                "__className" : "TestObject"
                        }
                },
                "hashHash" : {
                        "__id" : "10",
                        "2" : "hash",
                        "1" : {
                                "__id" : "33",

                                "b" : "complicated",
                                "a" : "Very"
                        },
                        "3" : {
                                "__id" : "51",

                                "a" : "of",
                                "z" : "hashes"
                        }
                },
                "hashArr" : {
                        "__id" : "39",
                        "3" : true,
                        "1" : ["hash","of"],
                        "2" : ["arrays"],
                        "4" : false
                },
                "arrHash" : [
                        {
                                "__id" : "3e",

                                "1" : "This",
                                "2" : "is"
                        },
                        {
                                "__id" : "65",

                                "b" : "hashes",
                                "a" : "array of"
                        }
                ]
        },
        "falseVal" : false

}
}


puts RubyAutopsist.Deserialize($jsonNET)

module A
  class Testing
    attr_accessor :val
  end
end

tst = A::Testing.new
#print tst.name



#$jsonNET = %q{
#{
#        "Id" : "2d",
#        "val1" : "MyTestClass",
#        "classVar" : {
#                "__id" : "bc",
#                "__className" : "Prob",
#                "test2" : 9999,
#                "classVar2" : {
#                        "__id" : "d3",
#                        "dateVal" : 1325376000000+0000,
#                        "val" : "3rd level class",
#                        "datetimeVal" : 981173106000+0000,
#                        "timeVal" : 1343711309000+0600,
#                        "__className" : "Prob2"
#                },
#                "test1" : "InnerClass Var1"
#        },
#        "val2" : 100500,
#        "trueVal" : true,
#        "__className" : "TestClass",
#        "pro" : {
#                "__id" : "a1",
#                "c" : 3,
#                "b" : 2,
#                "a" : 1
#        },
#        "name" : [1,2,3],
#        "anotherClass" : {
#                "__id" : "19",
#                "__className" : "AnotherClass",
#                "arrObj" : [
#                        {
#                                "__id" : "8e",
#
#                                "testVal" : "TestObj1 for Arrays",
#                                "__className" : "TestObject"
#                        },
#                        {
#                                "__id" : "07",
#
#                                "__className" : "TestObject",
#                                "testVal" : "TestObj2 for Arrays",
#                                "val2" : "Another val2"
#                        },
#                        {
#                                "__id" : "a4",
#
#                                "val3" : "obj3 val3",
#                                "__className" : "TestObject",
#                                "testVal" : "TestObj3 for Arrays",
#                                "val2" : "obj3 val2"
#                        }
#                ],
#                "arr" : ["This","is","array!"],
#                "hash" : {
#                        "__id" : "0d",
#                        "1" : "Regular hash"
#                },
#                "hashObj" : {
#                        "__id" : "a8",
#                        "1" : {
#                                "__id" : "d8",
#
#                                "__className" : "TestObject",
#                                "testVal" : 100500
#                        },
#                        "3" : {
#                                "__id" : "4d",
#
#                                "testVal" : "I must not be Lazy!!",
#                                "__className" : "TestObject"
#                        },
#                        "2" : {
#                                "__id" : "25",
#
#                                "testVal" : "Too Lazy",
#                                "__className" : "TestObject"
#                        }
#                },
#                "hashHash" : {
#                        "__id" : "10",
#                        "2" : "hash",
#                        "1" : {
#                                "__id" : "33",
#
#                                "b" : "comlicated",
#                                "a" : "Very"
#                        },
#                        "3" : {
#                                "__id" : "51",
#
#                                "a" : "of",
#                                "z" : "hashes"
#                        }
#                },
#                "hashArr" : {
#                        "__id" : "39",
#                        "3" : true,
#                        "1" : ["hash","of"],
#                        "2" : ["arrays"],
#                        "4" : false
#                },
#                "arrHash" : [
#                        {
#                                "__id" : "3e",
#
#                                "1" : "This",
#                                "2" : "is"
#                        },
#                        {
#                                "__id" : "65",
#
#                                "b" : "hashes",
#                                "a" : "array of"
#                        }
#                ]
#        },
#        "falseVal" : false
#}
#}

#print RubyAutopsist.Deserialize($jsonNET)


#print RubyAutopsist.Deserialize($jsonNET)
#print $jsonNET.class
















#tester = Tester.new
#varName = "@foo"
#varValue = "Hello, World!"
#tester.instance_variable_set(varName, varValue)










#guid = SecureRandom.uuid
#p guid.class

#$hashString = RubyAutopsist.GetObjectDetail(test).to_s
#

#print tracer.GetHash
#puts
#puts






# DATETIME HENTAI
#dt = DateTime.now
#puts dt
#puts dt.year
#puts dt.month
#puts dt.day
#puts dt.hour
#puts dt.minute
#puts dt.sec
#puts dt.zone

# VERY VERY GOOOOOOOD
#puts
#puts Time.at( 1161275493444 / 1000 )
#
#puts
#puts Time.parse(dt.to_s)
#puts dt.strftime("%Q %z").to_i
#puts dt.strftime("%z").to_s
#
#jsonDateTime = dt.strftime("%Q%z").to_s
#puts jsonDateTime
#puts
#
#date = Date.new(2012,1,1)
#puts date
#time = Time.now
#puts time
#
#def DateToDateTime(date)
#  DateTime.parse(date.to_s)
#end
#
#def TimeToDateTime(time)
#  DateTime.parse(time.to_s)
#end
#
#puts time.class
#puts TimeToDateTime(time).class
#puts date.class
#puts DateToDateTime(date).class












# Down are different HENTAI things

#class Prob2
#  attr_accessor :val
#end
#
#class Prob
#  attr_accessor :test1, :test2, :classVar
#
#  def Calc(a, b)
#    a + b
#  end
#end
#
#class TestClass
#  attr_accessor :val1, :val2, :classVar, :pro
#
#  def name
#    @name
#  end
#
#  def name= name
#    @name = name
#  end
#
#  def SayHello
#    print "Hello, World!!!"
#  end
#
#  def foo; end
#
#  def bar; end
#
#  def yamlix; end
#end
#
#test = TestClass.new
#test.val1 = "MyTestClass"
#test.val2 = 100500
#test.name = [1,2,3]
#test.classVar = Prob.new
#test.classVar.test1 = "InnerClass Var1"
#test.classVar.test2 = 9999
#test.classVar.classVar = Prob2.new
#test.pro = {"a" => 1, "b" => 2, "c" => 3}

#puts "Here are the names of all the class properties:"
#print test.instance_variables
#puts
#puts "using RubyAutopsist:"
#print RubyAutopsist.GetPropertyList test
#puts puts
#
#puts "Calling a method by name"
#test.method("SayHello").call
#puts  puts
#
#puts "List of all methods in the class"
#print (test.public_methods - Object.public_methods).sort
#puts
#puts "using RubyAutopsist:"
#print RubyAutopsist.GetMethodList test
#puts puts

#propertyName = RubyAutopsist.GetPropertyList(test)[0]
#print "Print the name of the first property in the class: "
#puts propertyName
#print "And its type: "
#puts test.name.class
#print "And the last... Its value: "
#puts test.instance_variable_get(propertyName)
#
#puts
#puts "Now let's do the same using RubyAutopsist..."
#puts
#
#puts "Here's the class Property Details:"
#print RubyAutopsist.GetPropertyDetail(test)
#print RubyAutopsist.GetPropertyList(test.instance_variable_get("@classVar"))
#print test.instance_variable_get("@classVar").class

# Input all Ruby types
#puts "13".class, 12.class, [1,2].class, {"a" => 1}.class, nil.class