require 'benchmark'

class X

  def self.x(arg1, arg2)
    arg1 + arg2
  end

  def initialize(arg1, arg2)
    @arg1 = arg1
    @arg2 = arg2
  end

  def x
    @arg1 + @arg2
  end

end

n = 500000
Benchmark.bmbm do |x|
  x.report("X.x     "){ n.times{ X.x(1,2) } }
  x.report("X.new.x "){ n.times{ X.new(1,2).x } }
end

