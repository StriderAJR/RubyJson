$: << 'D:/Programs/Univeris/Univeris.DLL'
#print $:

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
a.val1 = DateTime.Now
#puts a.val1.class

runner = Runner.new
p = runner.take(a)
p.as "p"

array = [1,2,3]
hash = {"a" => 1, "b"=>4}

runner.Where(p.val1.Equal 0)
#runner.OrderBy(p.val2)
#runner.Select(10.Less 12)
puts runner.Run

