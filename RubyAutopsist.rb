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
  require './AutopsistHelper'

  class Serializable
    attr_accessor :__class

    def initialize
      @__class = self.class.to_s
    end

    def add_attrs(attrs)
      attrs.each do |var, value|
        #class_eval { attr_accessor var }
        (class << self ; self ; end).class_eval { attr_accessor var }
        instance_variable_set "@#{var}", value
        end
    end
  end

  class RubyAutopsist
    @TYPE_LIST = [Symbol, String, Fixnum, Array, Hash, NilClass, TrueClass, FalseClass]
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

    def self.GetVariable(value)
      if value.class == String
        objectValue = value
      elsif value.class == Array
        objectValue = FeedArray(value)
      elsif value.class == Hash
        objectValue = CreateObject(value)
      end
      objectValue
    end

    def self.FeedObject(jsonHash, object)
      #object = Serializable.new
      jsonHash.each do |key, value|
        #objectValue = GetVariable(value)
        #object.instance_variable_set("@"+key, objectValue)
        objectValue = {key => GetVariable(value)}
        object.add_attrs(objectValue)
      end
      object
    end

    def self.FeedHash(jsonHash)
      hash = Hash.new
      jsonHash.each do |key, value|
        objectValue = GetVariable(value)
        hash[key] = objectValue
      end
      hash
    end

    def self.FeedArray(jsonArray)
      array = Array.new
      jsonArray.each do |value|
        objectValue = GetVariable(value)
        array.push(objectValue)
      end
      array
    end

    def self.CreateObject(jsonHash)
      #object = Serializable.new

      if jsonHash.has_key? "__class"
        # That's object
        className = jsonHash["__class"]

        begin
          classObj = Object.const_get className
          object = classObj.new

          rescue Exception => msg
            puts msg
        end
        object = FeedObject(jsonHash, object)
      else
        # That's hash
        hash = Hash.new
        object = FeedHash(jsonHash)
      end

      object
    end

    def self.GetHashFromJson(jsonString)
      AutopsistHelper.Step(jsonString, 0)[1]
    end

    #
    # Creates Json string for any type of object
    #
    def self.CreateJson(objectValue, tab)
      objectType = objectValue.class

      jsonString = ""

      if !(@TYPE_LIST.include? objectType) and !(@DATE_TYPE.include? objectType)
        jsonString = jsonString + "{\n"
        jsonString = jsonString + CreatePropertiesJson(objectValue, tab+1) +  AutopsistHelper.Tabs(tab-1) + "}"
      elsif objectType == Array
        jsonString = jsonString + CreateStructureJson(objectValue, tab+1)
      elsif objectType == Hash
        jsonString = jsonString + CreateStructureJson(objectValue, tab+1)
      elsif objectType == String or objectType == Symbol
        jsonString = jsonString + "\"" + objectValue.to_s + "\""
      elsif objectType == Fixnum
        jsonString = jsonString + objectValue.to_s
      elsif objectType == TrueClass
        jsonString = jsonString + "true"
      elsif objectType == FalseClass
        jsonString = jsonString + "false"
      elsif objectType == NilClass
        jsonString = jsonString + "null"
      elsif @DATE_TYPE.include? objectType
        jsonString = jsonString + JsonDate.ToMillisec(objectValue)

      else
        jsonString = jsonString + propertyValue.to_s
      end

      jsonString
    end

    #
    # Creates Json for an array or a hash
    #
    def self.CreateStructureJson(object, tab)
      jsonString = ""

      if object.class == Hash
        jsonString = "{\n"

        object.each do |key, value|
          jsonString = jsonString + AutopsistHelper.Tabs(tab) + "\"" + key.to_s + "\": "
          jsonString = jsonString + CreateJson(value, tab+1)

          if object.keys.last == key
            jsonString = jsonString + "\n"
          else
            jsonString = jsonString + ",\n"
          end
        end

        jsonString = jsonString + AutopsistHelper.Tabs(tab-2) + "}"

      elsif object.class == Array
        jsonString = "[\n"

        object.each_with_index do |element, index|
          jsonString = jsonString + AutopsistHelper.Tabs(tab)
          jsonString = jsonString + CreateJson(element, tab+1)

          if index == object.length - 1
            jsonString = jsonString + "\n"
          else
            jsonString = jsonString + ",\n"
          end
        end
        jsonString = jsonString + AutopsistHelper.Tabs(tab-2) + "]"

      end

      jsonString
    end

    #
    # Creates Json for all the properties in the object
    #
    def self.CreatePropertiesJson(object, tab)
      jsonString = ""
      propertyList = AutopsistHelper.GetPropertyList(object)
      propertyList.each_with_index do |property, index|
#        propertyType = object.instance_variable_get(property).class
        propertyValue = object.instance_variable_get(property)

        # Insert property Name
        jsonString = jsonString + AutopsistHelper.Tabs(tab) + "\"" + property.to_s.gsub("@", "") + "\"" + ": "

        # Insert property Value
        jsonString = jsonString + CreateJson(propertyValue, tab+1)

        if index == propertyList.length - 1
          jsonString = jsonString + "\n"
        else
          jsonString = jsonString + ",\n"
        end
      end
      jsonString
    end

    #
    # Returns the list of object methods (not required for Json serialization)
    #
    def self.GetMethodList(object)
      (object.public_methods - Object.public_methods).sort
    end

  end

end


##############################
###Serialization into Hash####
##############################

#
##
#    # Returns object properties as hash
#    #
#    def self.CreateObjectHash(object)
#      objectHash = Hash.new
#      objectHash[object.class.to_s] = [Class, self.CreatePropertiesHash(object)]
#      objectHash
#    end
#
#    #
#    # Returns all properties of an object as hash
#    #
#    def self.CreatePropertiesHash(object)
#      propertyList = AutopsistHelper.rb.GetPropertyList(object)
#      propertyHash = Hash.new
#      propertyList.each do |property|
#        propertyType = object.instance_variable_get(property).class
#        propertyValue = object.instance_variable_get(property)
#
#        if @TYPE_LIST.include? propertyType.to_s
#          propertyHash[property.to_s] = [propertyType, propertyValue]
#        else
#          propertyHash[property.to_s] = [Class, self.CreatePropertiesHash(propertyValue)]
#        end
#      end
#
#      propertyHash
#    end

