require "./RubyJsonSql"
require "./Linq"

include JsonSql
include Linq

class A
  attr_accessor :val1, :val2
end

a = A.new
a.val1 = "Hello!"
a.val2 = 100500

runner = Runner.new
p = runner.take(a)
p.as "p"

array = [1,2,3]
hash = {"a" => 1, "b"=>4}

runner.Where(p.val1.Equal 3)
runner.OrderBy(p.val2)
runner.Select(10.Less 12)
puts runner.Run



