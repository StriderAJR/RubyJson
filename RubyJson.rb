########################################################
#                         RubyJson                     #
#                Json Serializer for Ruby              #
########################################################
#               Created by Alex J. Ranger              #
#             alexander.aj.ranger@gmail.com            #
#                       July 2012                      #
########################################################


module Json
  require './RubyJsonExtension'

  include JsonWriter
  include JsonReader
  include JsonDecoder
  include JsonEncoder
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

    def self.DeserializeWithNoRestrictions(jsonString)
      jsonHash = JsonReader.GetHashFromJson(jsonString)

      JsonReader.CreateObject(jsonHash, false)
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
  end

end