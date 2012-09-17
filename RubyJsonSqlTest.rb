require "./RubyJsonSql"
require "./Linq"

include JsonSql

class A
  attr_accessor :val1, :val2
end


#array = [A]
#visitor = Visitor.new(array)
#visitor.as "p"
#puts visitor.val1

a = A.new

runner = Runner.new
p = runner.take(a)
p.as "p"

#runner.methods["Where"] = BinaryOp.And(1,BinaryOp.Equal(5, runner.visitor.val1))
#runner.methods["Select"] = UnaryOp.Not(4)


include Linq

array = [1,2,3]
hash = {"a" => 1, "b"=>4}

runner.Where(p.val1.Equal 3)
runner.OrderBy(p.val2)
runner.Select(10.Less 12)
puts runner.Run



