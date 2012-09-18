module JsonTools
  #
  # Finds class type in assemblies from its full class name
  #
  def GetClass(fullClassName)
    fullClassName.split('::').inject(Object) do |mod, className|
      mod.const_get(className)
    end
  end

  def GetClassNameArray(fullClassName)
    fullClassName.split('::')
  end

  def NetFullClassName(classNameArray)
    className = ""
    classNameArray.each do |member|
      className += member + "."
    end
    className[0..-2]
  end

  def RubyObject?
    netModules = ["System", "Univeris"]
    classNameArray = GetClassNameArray(self.class.to_s)

    if netModules.include? classNameArray[0]
      false
    else
      true
    end
  end

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

  def self.Scan(string, substring)
    res = []
    string.scan(substring) do |c|
      res << $~.offset(0)[0]
    end
    res
  end

  def self. AddTabs(string, tab)
    if (string.index("\n") != nil)
      string.insert(0, Tabs(tab))

      array = Scan(string,"\n")
      i = array.length-1

      while i >= 0
        string.insert(array[i]+1, Tabs(tab))
        i -= 1
      end
    end
    string
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

class Hash
  def reverse
    newHash = Hash.new
    keys = self.keys
    i = keys.length - 1

    while i >= 0 do
      newHash[keys[i]] = self[keys[i]]
      i -= 1
    end
    newHash
  end
end