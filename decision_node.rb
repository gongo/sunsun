class DecisionNode
  attr_accessor :col, :value, :results, :tb, :fb

  def initialize(args = {:col => -1})
    @col = args[:col]
    @value = args[:value] if args[:value]
    @results = args[:results] if args[:results]
    @tb = args[:tb] if args[:tb]
    @fb = args[:fb] if args[:fb]
  end
end
