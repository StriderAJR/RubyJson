module JsonTools
  #
  # Finds class type in assemblies from its full class name
  #
  def GetClass(fullClassName)
    fullClassName.split('::').inject(Object) do |mod, className|
      mod.const_get(className)
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