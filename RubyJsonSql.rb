module JsonSql
  def BuildExpressionTree(queryString)
    if queryString == "" or null
      raise "Empty or Null string parameter"
    end

    JsonSqlDecoder.Decode(queryString, "")
  end

end

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

  MethodsList = %w[MethodSelect MethodFirst MethodCount MethodOrderBy MethodOrderByDesc
                  MethodSkip MethodsList MethodTake MethodWhere]

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
end

module JsonSqlDecoder
  def Decode(jsonSqlString, expressionTree)

  end
end