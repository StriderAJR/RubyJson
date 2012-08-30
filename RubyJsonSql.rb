require './JsonTools'

include JsonTools

module QuerySchema
  # Json node schema:

  JsonNodeType = "NodeType"

  JsonNodeMethod = "Method"
  JsonNodeBinaryOperation = "BinaryOp"
  JsonNodeUnaryOperation = "UnaryOp"
  JsonNodeProperty = "Property"
  JsonNodeConstant = "Constant"

  JsonMethodName = "Name"
  JsonMethodArguments = "Arguments"

  JsonBinaryOperation = "Operation"
  JsonBinaryOperationLeft = "Left"
  JsonBinaryOperationRight = "Right"

  JsonUnaryOperation = "Operation"
  JsonUnaryOperationOperand = "Operand"

  JsonPropertyName = "Name"

  JsonConstantValue = "Value"

  # Query methods:

  MethodSelect = "Select"
  MethodFirst = "First"
  MethodCount = "Count"
  MethodWhere = "Where"
  MethodOrderBy = "OrderBy"
  MethodOrderByDesc = "OrderByDesc"
  MethodSkip = "Skip"
  MethodTake = "Take"

  MethodsList = Array.new
  MethodsList.push(MethodSelect, MethodFirst, MethodCount, MethodOrderBy, MethodOrderByDesc)
  MethodsList.push(MethodSkip, MethodsList, MethodTake, MethodWhere)

  # Binary logic operations:

  BinaryOperationContains = "IN"
  BinaryOperationAndAlso = "AND"
  BinaryOperationOrElse = "OR"
  BinaryOperationEqual = "="
  BinaryOperationNotEqual = "<>"
  BinaryOperationLessThan = "<"
  BinaryOperationLessThanOrEqual = "<="
  BinaryOperationGreaterThan = ">"
  BinaryOperationGreaterThanOrEqual = ">="

  # Unary logic operations:

  UnaryOperationNot = "NOT"

  # .Net Types

  NetTypes = Hash.new
  NetTypes["Guid"] = "System.Guid, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089"
  NetTypes["String"] = "System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089"
  NetTypes["Char"] = "System.Char, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089"
  NetTypes["Boolean"] = "System.Boolean, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089"
  NetTypes["DateTime"] = "System.DateTime, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089"
  NetTypes["TimeSpan"] = "System.TimeSpan, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089"
  NetTypes["Int16"] = "System.Int16, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089"
  NetTypes["Int32"] = "System.Int32, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089"
  NetTypes["UInt16"] = "System.UInt16, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089"
  NetTypes["UInt32"] = "System.UInt32, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089"
  NetTypes["Int64"] = "System.Int64, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089"
  NetTypes["UInt64"] = "System.UInt64, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089"
  NetTypes["Single"] = "System.Single, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089"
  NetTypes["Double"] = "System.Double, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089"
  NetTypes["Decimal"] = "System.Decimal, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089"
  NetTypes["Object"] = "System.Object, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089"
end

module JsonSql
  include QuerySchema

  def BuildExpressionTree(queryString)
    if queryString == "" or nil
      raise "Empty or Null string parameter"
    end

    pos = 0
    loop do
      output = JsonSqlDecoder.GetMemberName(queryString, pos)
      memberName = output[1]
      break if MethodsList.include? memberName
      pos = output[0] + 1
    end

    pos = JsonTools.SkipBlanks(queryString, pos)
    queryString = queryString[pos.. -1]

    #visitor = Visitor.new
    #visitor.expressionArray = []
    JsonSqlDecoder.Decode(queryString, visitor.expressionArray, 0)
  end
end

module JsonSql

  class Visitor
    attr_accessor :objList, :name

    def initialize(objList)
      @objList = objList
    end

    def as(name)
      @name = name
      self
    end

    def method_missing(methName, *args, &block)
      expression = "{\n"
      expression += JsonTools.Tabs(1) + "\"NodeType\" : \"Property\",\n"
      # TODO lists as arrays only


      propertyName = methName.to_s
      propertyName += "("
      begin
        fullClassName = GetClassName(@objList[0].instance_variable_get("@" + methName.to_s).class.to_s)
        if fullClassName.first == "System" and QuerySchema.NetTypes.include? fullClassName.last
          propertyName += NetTypes[fullClassName.last]
        else
          propertyName += NetFullClassName(fullClassName)
        end
      rescue Exception => msg
        puts msg
        puts "No property with name " + methName.to_s
      end
      propertyName += ")"


      expression += JsonTools.Tabs(1) + "\"Name\" : \"" + @name + "." + propertyName  + "\"\n"
      expression += "}"
    end
  end

  class Runner
    attr_accessor :expressionTree, :visitor, :methods

    def initialize()
      @expressionTree = ""
      @methods = Hash.new
    end

    def take(objList)
      @visitor = Visitor.new(objList)
    end

    def Run()
      @expressionTree = "{\n"

      keys = @methods.reverse.keys
      @expressionTree += PrintMethod(@methods, keys, 1)

      @expressionTree += "}"
    end

    def PrintMethod(methods, keys, tab = 0)
      expressionTree = ""
      keys.each do |key|
        expressionTree += JsonTools.Tabs(tab) + "\"NodeType\" : \"Method\",\n"
        expressionTree += JsonTools.Tabs(tab) + "\"Name\" : \"" + key + "\",\n"
        expressionTree += JsonTools.Tabs(tab) + "\"Arguments\" : [\n"
        if keys.length > 1
          keys.delete(key)
          expressionTree += PrintMethod(methods, keys, tab + 1)
        else
          expressionTree += JsonTools.Tabs(tab+1) + "null,\n"
        end
        expressionTree += JsonTools.AddTabs(methods[key], tab+1) + "\n"
        expressionTree += JsonTools.Tabs(tab) + "]\n"
      end
      expressionTree
    end

    def PrintArguments(tab)
      JsonTools.Tabs(tab) + "Here must be arguments"
    end
  end

  class BinaryOp
    def self.Expression(opName, right, left, tab = 0)
      expression = "{\n"
      expression += JsonTools.Tabs(tab) + "\"NodeType\" : \"BinaryOp\",\n"
      expression += JsonTools.Tabs(tab) + "\"Operation\" : \"" + opName + "\",\n"
      expression += JsonTools.Tabs(tab) + "\"Left\" : " + JsonTools.AddTabs(left.to_s, tab) + ",\n"
      expression += JsonTools.Tabs(tab) + "\"Right\" : " + JsonTools.AddTabs(right.to_s, tab) + "\n"
      expression += "}"
      expression
    end

    def self.Equal(right, left, tab = 0)
      Expression("=", right, left, tab + 1)
    end

    def self.More(right, left, tab = 0)
      Expression(">", right, left, tab + 1)
    end

    def self.Less(right, left, tab = 0)
      Expression("<", right, left, tab + 1)
    end

    def self.LessOrEqual(right, left, tab = 0)
      Expression("<=", right, left, tab + 1)
    end

    def self.MoreOrEqual(right, left, tab = 0)
      Expression(">=", right, left, tab + 1)
    end

    def self.NotEqual(right, left, tab = 0)
      Expression("<>", right, left, tab + 1)
    end

    def self.In(right, left, tab = 0)
      # TODO Here's a little more complicated
      Expression("IN", right, left, tab + 1)
    end

    def self.And(right, left, tab = 0)
      Expression("AND", right, left, tab + 1)
    end

    def self.Or(right, left, tab = 0)
      Expression("OR", right, left, tab + 1)
    end
  end
end

class UnaryOp
  def self.Expression(opName, operand, tab = 0)
    expression = "{\n"
    expression += JsonTools.Tabs(tab) + "\"NodeType\" : \"UnaryOp\",\n"
    expression += JsonTools.Tabs(tab) + "\"Operation\" : \"" + opName + "\",\n"
    expression += JsonTools.Tabs(tab) + "\"Operand\" : " + JsonTools.AddTabs(operand.to_s, tab) + "\n"
    expression += "}"
  end

  def self.Not(operand, tab = 0)
    Expression("NOT", operand, tab+1)
  end
end

module JsonSqlDecoder
  def self.Decode(jsonSqlString, expressionTree, pos)
    symbolsUpcase = ('A'..'Z')
    symbolsLowcase = ('a'..'z')

    pos = 0
    state = 0
    stopFlag = false

    while stopFlag == false
      char = jsonSqlString[pos]

      case state
        when 0
          pos = JsonTools.SkipBlanks(jsonSqlString, pos)

      end

      pos = pos + 1
    end

  end

  def self.GetMemberName(jsonSqlString, pos)
    separators = [".", " ", "\n", "\t", "("]
    pos = JsonTools.SkipBlanks(jsonSqlString, pos)

    memberName = ""
    until separators.include? jsonSqlString[pos]
      memberName += jsonSqlString[pos]
      pos += 1
    end

    [JsonTools.SkipBlanks(jsonSqlString, pos), memberName]
  end
end