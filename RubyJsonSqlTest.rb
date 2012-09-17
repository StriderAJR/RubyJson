require "./RubyJsonSql"
require "./Linq"

include JsonSql

class A
  attr_accessor :val1, :val2
end


array = [A]
#visitor = Visitor.new(array)
#visitor.as "p"
#puts visitor.val1



runner = Runner.new
runner.take(array).as "p"

runner.methods["Where"] = BinaryOp.And(1,BinaryOp.Equal(5, runner.visitor.val1))
runner.methods["Select"] = UnaryOp.Not(4)


#puts runner.Run

#a = 1+2
#puts a
#puts a.class

include Linq

#puts [1,2].Equal 6
puts runner.Where(6.Equal "a".More "c")


