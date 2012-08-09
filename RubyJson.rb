########################################################
#                         RubyJson                     #
#                Json Serializer for Ruby              #
########################################################
#               Created by Alex J. Ranger              #
#             alexander.aj.ranger@gmail.com            #
#                       July 2012                      #
########################################################


module Json
  require 'date'
  require 'time'
  require './JsonDate'
  require './RubyJsonExtension'

  include JsonWriter
  include JsonDecoder
  include JsonTools


  class Serializable
    attr_accessor :__class

    def initialize
      @__class = self.class.to_s
    end

    def add_attrs(attrs)
      attrs.each do |var, value|
        #class_eval { attr_accessor var }
        (class << self ; self end).class_eval { attr_accessor var }
        instance_variable_set "@#{var}", value
        end
    end
  end

  class RubyJson
    #
    # Returns Json of an object
    #
    def self.Serialize(object)
      JsonWriter.CreateJson(object, 0)
    end

    #
    #  Returns Ruby object
    #
    def self.Deserialize(jsonString)
      jsonHash = JsonReader.GetHashFromJson(jsonString)

      JsonReader.CreateObject(jsonHash)
    end
  end

  #############################################
  # RubyJson mapper for IronRuby calls
  #############################################
  class RubyProvider
    def GetHash
      $hashString
    end

    def GetJson
      $jsonString
    end

    def Serialize(object)
      $jsonString = RubyJson.Serialize(object)
    end

    def Deserialize(json)
      $object = RubyJson.Deserialize(json)
    end

    def GetClassName
      $className
    end

    def GetRubyObject
      $object
    end

    def PrintRubyObject
      puts $object.Id
      puts $object.Id.class
      puts

      puts $object.val1
      puts $object.val1.class
      puts

      puts $object.val2
      puts $object.val2.class
      puts

      puts $object.name
      puts $object.name.class
      puts

      puts $object.classVar.test1
      puts $object.classVar.test1.class
      puts

      puts $object.classVar.test2
      puts $object.classVar.test2.class
      puts

      puts $object.classVar.classVar2
      puts $object.classVar.classVar2.class
      puts

      puts $object.classVar.classVar2.val
      puts $object.classVar.classVar2.val.class
      puts

      puts $object.classVar.classVar2.timeVal
      puts $object.classVar.classVar2.timeVal.class
      puts

      puts $object.classVar.classVar2.dateVal
      puts $object.classVar.classVar2.dateVal.class
      puts

      puts $object.classVar.classVar2.datetimeVal
      puts $object.classVar.classVar2.datetimeVal.class
      puts

      puts $object.pro
      puts $object.pro.class
      puts

      puts $object.trueVal
      puts $object.trueVal.class
      puts

      puts $object.falseVal
      puts $object.falseVal.class
      puts

      puts $object.nilVal
      puts $object.nilVal.class
      puts

      puts $object.anotherClass.arrHash
      puts $object.anotherClass.arrHash.class
      puts

      puts $object.anotherClass.arrArr
      puts $object.anotherClass.arrArr.class
      puts

      puts $object.anotherClass.arrObj
      puts $object.anotherClass.arrObj.class
      puts

      puts $object.anotherClass.hash
      puts $object.anotherClass.hash.class
      puts

      puts $object.anotherClass.hashArr
      puts $object.anotherClass.hashArr.class
      puts

      puts $object.anotherClass.hashHash
      puts $object.anotherClass.hashHash.class
      puts

      puts $object.anotherClass.hashObj
      puts $object.anotherClass.hashObj.class
      puts
    end
  end

end