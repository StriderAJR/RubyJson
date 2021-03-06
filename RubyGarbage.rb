##############################
# DateTime
##############################

#puts DateTime.parse('20010203T040506+0700')

#datetime = DateTime.new(2001,2,3,4,5,7,'+0200')
##datetime = DateTime.now
#puts datetime
#dateString = datetime.strftime("%Q%z").to_s
#time = Time.at(dateString.to_i/1000)
#date = time.to_datetime
##date.new_offset('+5')
#puts date
#puts

##############################
# Escape sequences
###############################
#puts object.val2.class
#str = ""
#str = str + "asd"
#puts object.val1

#puts
#code = "0009"
#escape = "\u" + code
#puts "Hello" + escape + "World"

#################################
# Fixnum, Float, BigDecimal, Bignum
##################################

#i = 1000000000
#while i.class == Fixnum
#  i = i + 1
#end
#puts i.to_s + " is the first Bignum value"
#bignum = 1073741824

#f = 0.6666666666666666666666666666666666666666666666666# + 0.333333333333333333333333333333333333333333333
#puts f.to_s

#i = Integer("66666666")
#puts i.class


####################################
# Getting symbol code
###########################################

#str = "\t"
#print str.unpack('U*').map{ |i| "\\u" + i.to_s(16).rjust(4, '0') }.join


#$jsonNET = %q{
#{
#        "__class" : "TestClass",
#        "Id" : "2d",
#        "val1" : "MyTestClass",
#        "classVar" : {
#                        "__id" : "bc",
#                        "__class" : "Prob",
#                        "test2" : 9999,
#                        "classVar2" : {
#                                "__id" : "d3",
#                                "dateVal" : 1325376000000+0000,
#                                "val" : "3rd level class",
#                                "datetimeVal" : 981173106000+0000,
#                                "timeVal" : 1343711309000+0600,
#                                "__class" : "Prob2"
#                        },
#                        "test1" : "InnerClass Var1"
#                }
#}
#}

#$jsonNET = %q{
#{
#        "Id" : "2d",
#        "val1" : "MyTestClass",
#        "classVar" : {
#                "__id" : "bc",
#                "__class" : "Prob",
#                "test2" : 9999,
#                "classVar2" : {
#                        "__id" : "d3",
#                        "dateVal" : 1325376000000+0000,
#                        "val" : "3rd level class",
#                        "datetimeVal" : 981173106000+0000,
#                        "timeVal" : 1343711309000+0600,
#                        "__class" : "Prob2"
#                },
#                "test1" : "InnerClass Var1"
#        },
#        "val2" : 100500,
#        "trueVal" : true,
#        "__class" : "TestClass",
#        "pro" : {
#                "__id" : "a1",
#                "c" : 3,
#                "b" : 2,
#                "a" : 1
#        },
#        "name" : [1,2,3],
#        "anotherClass" : {
#                "__id" : "19",
#                "__class" : "AnotherClass",
#                "arrObj" : [
#                        {
#                                "__id" : "8e",
#
#                                "testVal" : "TestObj1 for Arrays",
#                                "__class" : "TestObject"
#                        },
#                        {
#                                "__id" : "07",
#
#                                "__class" : "TestObject",
#                                "testVal" : "TestObj2 for Arrays",
#                                "val2" : "Another val2"
#                        },
#                        {
#                                "__id" : "a4",
#
#                                "val3" : "obj3 val3",
#                                "__class" : "TestObject",
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
#                                "__class" : "TestObject",
#                                "testVal" : 100500
#                        },
#                        "3" : {
#                                "__id" : "4d",
#
#                                "testVal" : "I must not be Lazy!!",
#                                "__class" : "TestObject"
#                        },
#                        "2" : {
#                                "__id" : "25",
#
#                                "testVal" : "Too Lazy",
#                                "__class" : "TestObject"
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

#rubyObject = Object.new
#rubyObject = RubyAutopsist.Deserialize($jsonNET)
#rubyObject.class = TestClass
#print rubyObject.val1


#####################################
# Testing dynamic properties
#####################################

#class Client
#  def add_attrs(attrs)
#    attrs.each do |var, value|
#      #class_eval { attr_accessor var }
#      (class << self ; self ; end).class_eval { attr_accessor var }
#      instance_variable_set "@#{var}", value
#    end
#  end
#end

#
#client = Client.new
#hash = {"val1" => "Hello"}
#client.add_attrs(hash)
#hash = {"val2" => "123"}
#client.add_attrs(hash)
#puts client.val1
#puts client.val2
#puts
#
#puts RubyAutopsist.Serialize(client)

#####################################
# Full class name testing
#####################################

#module A
#  class AClass < Serializable
#    attr_accessor :val
#  end
#end
#
#a = A::AClass.new
#a.val = 100500
#
#p a.val
#p a.class.name
#p a.__class

###################################
# Deserialization into Hash testing
###################################

#$className = test.class
#
#print tracer.GetJson
#puts

#hash = RubyAutopsist.Deserialize($jsonNET)
#arrayHash = hash["arrArr"]
#str = arrayHash[2][1]
#print str

#print RubyAutopsist.Deserialize($jsonNET)

#puts $jsonString
#puts
#puts RubyAutopsist.Deserialize($jsonString)

#puts RubyAutopsist.Deserialize($jsonNET)

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

############################################
# Getting property by name
############################################

#tester = Tester.new
#varName = "@foo"
#varValue = "Hello, World!"
#tester.instance_variable_set(varName, varValue)

##########################
# Guid generation
##########################

#guid = SecureRandom.uuid
#p guid.class

#$hashString = RubyAutopsist.GetObjectDetail(test).to_s
#

#print tracer.GetHash
#puts
#puts

#########################
# DateTime Testing
#########################

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

#####################################
# Complicated class structures
#####################################

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

#######################################
# Old RubyLinq sintax
#######################################

#runner = Runner.new
#p = runner.take(a)
#p.as "p"

#runner.methods["Where"] = BinaryOp.And(1,BinaryOp.Equal(5, runner.visitor.val1))
#runner.methods["Select"] = UnaryOp.Not(4)

#puts runner.Run

#######################################
# New RubyLinq sintax
#######################################

#runner = Runner.new
#p = runner.take(a)
#p.as "p"

#runner.Where(p.val1.Equal 0)
#runner.OrderBy(p.val2)
#runner.Select(10.Less 12)
#puts runner.Run

##########################################################
# That's how you can call property and method in one way
##########################################################

#puts b.send("hour")

########################################
# Converting Ruby types into .Net types
########################################

#c = 3
#cn = c.class.to_clr_type
#puts cn