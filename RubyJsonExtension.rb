require './RubyJson.rb'
require 'date'
require 'time'
require 'securerandom'

module JsonReader
  #
  # Returns array of all properties of targeted object
  #
  def self.GetPropertyList(object)
    object.instance_variables
  end

  def self.GetElem(jsonString, pos)
    escape_sequences = {"0008" => "\b", "0009" => "\t", "000a" => "\n", "000c" => "\f", "000d" => "\r"}

    pos = JsonTools.SkipBlanks(jsonString, pos)
    char = jsonString[pos]
    arrayElem = ""

    if char == "\""
      pos = pos + 1 # Skip "
      char = jsonString[pos]
      while char != "\""
        if char == "\\"
          pos = pos + 1
          char = jsonString[pos]

          if char == "u"
            code = jsonString[pos+1..pos+4]
            char = escape_sequences[code]
            pos = pos + 4
          end
        end

        arrayElem = arrayElem + char

        pos = pos+1
        char = jsonString[pos]
      end
      pos = pos + 1 # Skip "
    else
      while char != "," and char != "]" and char != "}"
        arrayElem = arrayElem + char

        pos = JsonTools.SkipBlanks(jsonString, pos + 1)
        char = jsonString[pos]
      end
    end

    out = [pos, arrayElem]
  end

  def self.GetArray(jsonString, pos)
    array = Array.new
    outArray = Array.new
    arrayElem = ""

    pos = JsonTools.SkipBlanks(jsonString, pos)
    char = jsonString[pos]

    while char != "]"
      if char == "{"
        outArray = JsonEncoder.Step(jsonString, pos)
        pos = outArray[0]
        arrayElem = outArray[1]
        pos = JsonTools.SkipBlanks(jsonString, pos)
      elsif char == "["
        pos = JsonTools.SkipBlanks(jsonString, pos+1)
        outArray = JsonReader.GetArray(jsonString, pos)
        pos = outArray[0]
        arrayElem = outArray[1]
      elsif char == ","
        array.push(arrayElem)
        arrayElem = ""
        pos = JsonTools.SkipBlanks(jsonString, pos+1)
      else
        out = JsonReader.GetElem(jsonString, pos)
        pos = out[0]
        arrayElem = out[1]
      end

      pos = JsonTools.SkipBlanks(jsonString, pos)
      char = jsonString[pos]
    end

    array.push(arrayElem)
    outArray[0] = pos + 1
    outArray[1] = array
    outArray
  end

  def self.GetPropertyName(jsonString, pos)
    propertyName = ""

    while jsonString[pos] != "\""
      propertyName = propertyName + jsonString[pos]
      pos = pos + 1
    end
    out = [pos + 1, propertyName] # pos + 1 to skip "
  end

  #
  # Returns variable of needed type
  #
  def self.GetVariable(value)
    if value.class == String
      objectValue = JsonDecoder.DecodeValue(value)
    elsif value.class == Array
      objectValue = JsonEncoder.FeedArray(value)
    elsif value.class == Hash
      objectValue = RubyJson.CreateObject(value)
    end
    objectValue
  end

  #
  # Returns the list of object methods (not required for Json serialization)
  #
  def self.GetMethodList(object)
    (object.public_methods - Object.public_methods).sort
  end
end

module JsonEncoder
  #
  # Creates Json for an array or a hash
  #
  def self.CreateStructureJson(object, tab)
    jsonString = ""

    if object.class == Hash
      jsonString = "{\n"

      object.each do |key, value|
        jsonString = jsonString + JsonTools.Tabs(tab) + "\"" + key.to_s + "\": "
        jsonString = jsonString + RubyJson.CreateJson(value, tab+1)

        if object.keys.last == key
          jsonString = jsonString + "\n"
        else
          jsonString = jsonString + ",\n"
        end
      end

      jsonString = jsonString + JsonTools.Tabs(tab-2) + "}"

    elsif object.class == Array
      jsonString = "[\n"

      object.each_with_index do |element, index|
        jsonString = jsonString + JsonTools.Tabs(tab)
        jsonString = jsonString + RubyJson.CreateJson(element, tab+1)

        if index == object.length - 1
          jsonString = jsonString + "\n"
        else
          jsonString = jsonString + ",\n"
        end
      end
      jsonString = jsonString + JsonTools.Tabs(tab-2) + "]"

    end

    jsonString
  end

  #
  # Creates Json for all the properties in the object
  #
  def self.CreatePropertiesJson(object, tab)
    jsonString = ""
    propertyList = JsonReader.GetPropertyList(object)
    propertyList.each_with_index do |property, index|
      propertyValue = object.instance_variable_get(property)

      # Insert property Name
      jsonString = jsonString + JsonTools.Tabs(tab) + "\"" + property.to_s.gsub("@", "") + "\"" + ": "

      # Insert property Value
      jsonString = jsonString + RubyJson.CreateJson(propertyValue, tab+1)

      if index == propertyList.length - 1
        jsonString = jsonString + "\n"
      else
        jsonString = jsonString + ",\n"
      end
    end
    jsonString
  end

  def self.Step(jsonString, pos)
    pos = JsonTools.SkipBlanks(jsonString, pos)

    propertyName = ""
    propertyValue = ""
    jsonHash = Hash.new

    state = 0
    stopFlag = false

    while stopFlag == false

      char = jsonString[pos]

      case state
        when 0  # Object beginning (object and hash here are similar, they will be separated later)
          if char == "{"
            pos = JsonTools.SkipBlanks(jsonString, pos+1)
            state = 1
          end

        when 1 # Skipping separators
          if char == "\""
            out = JsonReader.GetPropertyName(jsonString, pos+1)
            pos = out[0]
            propertyName = out[1]
            state = 1
          elsif char == ":"
            pos = pos + 1
            state = 3
          elsif char == "}"
            pos = pos + 1
            stopFlag = true
          end

          pos = JsonTools.SkipBlanks(jsonString, pos)

        when 3 # Defining the type of propertyValue
          if char == "{"
            out = Step(jsonString, pos)
          elsif char == "["
            out = JsonReader.GetArray(jsonString, pos+1)
          else
            out = JsonReader.GetElem(jsonString, pos)
          end

          pos = out[0]
          propertyValue = out[1]
          state = 6
          pos = JsonTools.SkipBlanks(jsonString, pos)

        when 6 # Iteration
          if char == "," or char == "}"
            if propertyName != "" and propertyValue != ""
              jsonHash[propertyName] = propertyValue
              propertyName = ""
              propertyValue = ""
            end
          end

          if char == ","
            pos = JsonTools.SkipBlanks(jsonString, pos+1)
            state = 1
          end

          if char == "}"
            stopFlag = true
          end

      end

    end
    out[0] = pos + 1
    out[1] = jsonHash
    out
  end

  #
  # Fills object with values
  #
  def self.FeedObject(jsonHash, object)
    #object = Serializable.new
    jsonHash.each do |key, value|
      #objectValue = GetVariable(value)
      #object.instance_variable_set("@"+key, objectValue)
      objectValue = {key => JsonReader.GetVariable(value)}
      object.add_attrs(objectValue)
    end
    object
  end

    #
    # Fills hash with values
    #
    def self.FeedHash(jsonHash)
      hash = Hash.new
      jsonHash.each do |key, value|
        objectValue = JsonReader.GetVariable(value)
        hash[key] = objectValue
      end
      hash
    end

    #
    # Fills an array with values
    #
    def self.FeedArray(jsonArray)
      array = Array.new
      jsonArray.each do |value|
        objectValue = JsonReader.GetVariable(value)
        array.push(objectValue)
      end
      array
    end
end

module JsonDecoder
  def self.DecodeValue(value)
    if value == "null"
      nil
    elsif EncodedValueIsTrue(value)
      true
    elsif EncodedValueIsFalse(value)
      false
    elsif EncodedValueIsDateTime(value)
      DecodeValueToDateTime(value)
    elsif EncodedValueIsGuid(value)
      value
    elsif EncodedValueIsFloat(value)
      DecodeValueToFloat(value)
    elsif EncodedValueIsFixnum(value)
      DecodeValueToInteger(value)
    else
      value
    end
  end

  #
  # Parses json screening and escape sequences
  #
  def self.JsonString(string)
    jsonString = ""
    escape_sequences = ["\n", "\t", "\b", "\a", "\r", "\f"]
    scanning_sequences = ["\"", "/", "\\"]

    string.each_char do |char|
      if escape_sequences.include? char
        jsonString = jsonString + JsonTools.GetUniCode(char)
      elsif scanning_sequences.include? char
        jsonString = jsonString + "\\" + char
      else
        jsonString = jsonString + char
      end
    end

    jsonString
  end

  def EncodedValueIsTrue(value)
    if value == "true"
      true
    else
      false
    end
  end

  def EncodedValueIsFalse(value)
    if value == "false"
      true
    else
      false
    end
  end

  def EncodedValueIsDateTime(value)
    if value[0..4] == "/Date" and value[-2,2] == ")/"
      true
    else
      false
    end
  end

  def EncodedValueIsGuid(value)
    !!(value =~/^(\{?([0-9a-fA-F]){8}-([0-9a-fA-F]){4}-([0-9a-fA-F]){4}-([0-9a-fA-F]){4}-([0-9a-fA-F]){12}\}?)$/)
  end

  def EncodedValueIsFloat(value)
    !!(value =~/^[+-]?[0-9]+[.][0-9]+$/)
  end

  def EncodedValueIsFixnum(value)
    !!(value =~ /^[-+]?[0-9]+$/)
  end

  def DecodeValueToDateTime(value)
    time = Time.at(value[6..-3].to_i/1000)
    hour = time.hour - time.utc_offset/3600
    DateTime.new(time.year, time.month, time.mday, hour, time.min, time.sec, value[-7..-3])
  end

  def DecodeValueToFloat(value)
    accuracy = value.length - value.index(".") - 1

    if accuracy > 16
      BigDecimal.new(value)
    else
      value.to_f
    end
  end

  def DecodeValueToInteger(value)
    Integer(value)
  end
end

module JsonTools
  #
  # Sets several tabs for a better look
  #
  def self.Tabs(tab)
    tabs = ""
    (1..tab).each { |i|
      tabs = tabs + "\t"
    }
    tabs
  end

  def self.SkipBlanks(jsonString, pos)
    blanks = [" ", "\n", "\t"]
    while blanks.include? jsonString[pos]
      pos = pos + 1
    end
    pos
  end

  #
  # Gets codes of all symbols in the string
  #
  def self.GetUniCode(str)
    str.unpack('U*').map{ |i| "\\u" + i.to_s(16).rjust(4, '0') }.join
  end

end