class MyQueue

  def initialize
    @nodes = []
  end

  def first
    @nodes.first
  end

  def <<(element)
    @nodes << element
  end

  def shift
    @nodes.shift
  end

  def empty?
    @nodes.empty?
  end

  def present?
    !empty?
  end

  def print
    Kernel.puts @nodes.collect {|node|"(#{node.x},#{node.y})"}.join(", ")
  end

end