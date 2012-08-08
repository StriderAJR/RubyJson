########################################################
#                      RubyAutopsist                   #
#                Json Serializer for Ruby              #
########################################################
#               Created by Alex J. Ranger              #
#             alexander.aj.ranger@gmail.com            #
#                       July 2012                      #
########################################################


module Autopsist
  require 'date'
  require 'time'
  require './JsonDate'
  require './RubyJsonExtension'

  include JsonEncoder
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
    @TYPE_LIST = [Symbol, String, Fixnum, Numeric, Float, Rational, Array, Hash, NilClass, TrueClass, FalseClass]
    @DATE_TYPE = [Date, Time, DateTime]

    #
    # Returns Json of an object
    #
    def self.Serialize(object)
      CreateJson(object, 0)
    end

    def self.Deserialize(jsonString)
      jsonHash = GetHashFromJson(jsonString)

      CreateObject(jsonHash)
    end

    private

    #
    # Creates an object of the specified class OR hash
    #
    def self.CreateObject(jsonHash)
      if jsonHash.has_key? "__class"
        # That's object
        className = jsonHash["__class"]

        begin
          classObj = Object.const_get className
          object = classObj.new

          rescue Exception => msg
            puts msg
        end
        object = JsonEncoder.FeedObject(jsonHash, object)
      else
        # That's hash
        #hash = Hash.new
        object = JsonEncoder.FeedHash(jsonHash)
      end

      object
    end



    #
    # Wrap method to get hash from jsonString
    #
    def self.GetHashFromJson(jsonString)
      JsonEncoder.Step(jsonString, 0)[1]
    end

    #
    # Creates Json string for any type of object
    #
    def self.CreateJson(objectValue, tab)
      objectType = objectValue.class

      jsonString = ""

      if !(@TYPE_LIST.include? objectType) and !(@DATE_TYPE.include? objectType)
        # object is class
        jsonString = jsonString + "{\n"
        jsonString = jsonString + JsonEncoder.CreatePropertiesJson(objectValue, tab+1) +  JsonTools.Tabs(tab-1) + "}"
      elsif objectType == Array
        jsonString = jsonString + JsonEncoder.CreateStructureJson(objectValue, tab+1)
      elsif objectType == Hash
        jsonString = jsonString + JsonEncoder.CreateStructureJson(objectValue, tab+1)
      elsif objectType == String or objectType == Symbol
        jsonString = jsonString + "\"" + JsonDecoder.JsonString(objectValue) + "\""
      elsif objectType == TrueClass
        jsonString = jsonString + "true"
      elsif objectType == FalseClass
        jsonString = jsonString + "false"
      elsif objectType == NilClass
        jsonString = jsonString + "null"
      elsif @DATE_TYPE.include? objectType
        jsonString = jsonString + JsonDate.GetJsonDate(objectValue)
      else
        jsonString = jsonString + objectValue.to_s
      end

      jsonString
    end

  end

end