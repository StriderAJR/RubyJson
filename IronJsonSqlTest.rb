$: << 'D:/Programs/Univeris/Univeris.DLL'

include System

require "./RubyJsonSql"
require "./Linq"

include JsonSql
include Linq

int = Integer.new
int = 3

class A
  attr_accessor :val1, :val2
end

a = A.new
a.val1 = 3
a.val2 = DateTime.new(1999,12,12,14,15,16)

runner = Runner.new
p = runner.take(a)
p.as "p"

#array = [1,2,3]
#hash = {"a" => 1, "b"=>4}

runner.Where(p.val1.Equal 0).OrderBy(p.val2).Select(10.Less 12)
puts runner.Run


