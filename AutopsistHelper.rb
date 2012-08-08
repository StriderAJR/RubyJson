require 'date'
require 'time'
require 'securerandom'

module AutopsistHelper
    #
    # Returns array of all properties of targeted object
    #
    def self.GetPropertyList(object)
      object.instance_variables
    end

    #
    # Sets several tabs for a better look
    #
    def self.Tabs(tab)
      tabs = ""
      for i in 1..tab
        tabs = tabs + "\t"
      end
      tabs
    end

    def self.SkipBlanks(jsonString, pos)
      blanks = [" ", "\n", "\t"]
      while blanks.include? jsonString[pos]
        pos = pos + 1
      end
      pos
    end

    def self.GetElem(jsonString, pos)
      escape_sequences = {"0008" => "\b", "0009" => "\t", "000a" => "\n", "000c" => "\f", "000d" => "\r"}

      pos = SkipBlanks(jsonString, pos)
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

          pos = SkipBlanks(jsonString, pos + 1)
          char = jsonString[pos]
        end
      end

      out = [pos, arrayElem]
    end

    def self.GetArray(jsonString, pos)

   array = Array.new
      outArray = Array.new
      arrayElem = ""

      pos = SkipBlanks(jsonString, pos)
      char = jsonString[pos]

      while char != "]"
        if char == "{"
          outArray = Step(jsonString, pos)
          pos = outArray[0]
          arrayElem = outArray[1]
          pos = SkipBlanks(jsonString, pos)
        elsif char == "["
          pos = SkipBlanks(jsonString, pos+1)
          outArray = GetArray(jsonString, pos)
          pos = outArray[0]
          arrayElem = outArray[1]
        elsif char == ","
          array.push(arrayElem)
          arrayElem = ""
          pos = SkipBlanks(jsonString, pos+1)
        else
          out = GetElem(jsonString, pos)
          pos = out[0]
          arrayElem = out[1]
        end

        pos = SkipBlanks(jsonString, pos)
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

    def self.Step(jsonString, pos)
      pos = SkipBlanks(jsonString, pos)

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
              pos = SkipBlanks(jsonString, pos+1)
              state = 1
            end

          when 1 # Skipping separators
            if char == "\""
              out = GetPropertyName(jsonString, pos+1)
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

            pos = SkipBlanks(jsonString, pos)

          when 3 # Defining the type of propertyValue
            if char == "{"
              out = Step(jsonString, pos)
            elsif char == "["
              out = GetArray(jsonString, pos+1)
            else
              out = GetElem(jsonString, pos)
            end

            pos = out[0]
            propertyValue = out[1]
            state = 6
            pos = SkipBlanks(jsonString, pos)

          when 6 # Iteration
            if char == "," or char == "}"
              if propertyName != "" and propertyValue != ""
                jsonHash[propertyName] = propertyValue
                propertyName = ""
                propertyValue = ""
              end
            end

            if char == ","
              pos = SkipBlanks(jsonString, pos+1)
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
  # Gets codes of all symbols in the string
  #
  def self.GetUniCode(str)
    str.unpack('U*').map{ |i| "\\u" + i.to_s(16).rjust(4, '0') }.join
  end

end

module JsonEncoder
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

  #def EncodedValueIsTimeSpan(value)
  #
  #end

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

  #def DecodeValueToTimeSpan(value)
  #
  #end

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