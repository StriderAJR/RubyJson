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
a.val1 = 3
a.val2 = DateTime.new(1999,12,12,14,15,16)

#puts a.val1.class

runner = Runner.new
p = runner.take(a)
p.as "p"

#array = [1,2,3]
#hash = {"a" => 1, "b"=>4}

runner.Where(p.val1.Equal 0)
runner.OrderBy(p.val2)
runner.Select(10.Less 12)
puts runner.Run

#puts b.send("hour")
#puts a.send("val1")
##puts b.("@hour")
#puts
#
#c = 3
#cn = c.class.to_clr_type
#puts cn
#puts
#
#hash = Hash.new
#hash["a"] = 1
#hash["b"] = 2
#puts hash["a"]
#puts hash["c"]

