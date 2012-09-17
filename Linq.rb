module Linq
  def Expression(opName, right, left, tab = 0)
    expression = "{\n"
    expression += JsonTools.Tabs(tab) + "\"NodeType\" : \"BinaryOp\",\n"
    expression += JsonTools.Tabs(tab) + "\"Operation\" : \"" + opName + "\",\n"
    expression += JsonTools.Tabs(tab) + "\"Left\" : " + JsonTools.AddTabs(left.to_s, tab) + ",\n"
    expression += JsonTools.Tabs(tab) + "\"Right\" : " + JsonTools.AddTabs(right.to_s, tab) + "\n"
    expression += "}"
    expression
  end

  def Equal(operand)
    Expression("=", operand, self, 1)
  end

  def More(operand)
    Expression(">", operand, self, 1)
  end

  def Less(operand)
    Expression("<", operand, self, 1)
  end

  def LessOrEqual(operand)
    Expression("<=", operand, self, 1)
  end

  def MoreOrEqual(operand)
    Expression(">=", operand, self, 1)
  end

  def NotEqual(num)
    Expression("<>", num, self, 1)
  end

  def In(operand)
    # TODO Here's a little more complicated
    Expression("IN", operand, self, 1)
  end

  def And(operand)
    Expression("AND", operand, self, 1)
  end

  def Or(operand)
    Expression("OR", operand, self, 1)
  end

  def ExpressionUn(opName, operand, tab = 0)
    expression = "{\n"
    expression += JsonTools.Tabs(tab) + "\"NodeType\" : \"UnaryOp\",\n"
    expression += JsonTools.Tabs(tab) + "\"Operation\" : \"" + opName + "\",\n"
    expression += JsonTools.Tabs(tab) + "\"Operand\" : " + JsonTools.AddTabs(operand.to_s, tab) + "\n"
    expression += "}"
  end

  def Not(operand)
    ExpressionUn("NOT", operand, 1)
  end

  def Contains(operand)
    Expression("IN", self, operand, 1)
  end

  #class Fixnum
  #  include Linq
  #end
end