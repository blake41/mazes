class Queue

  def initialize
    @nodes = []
  end

  def first
    @nodes.first
  end

  def <<(element)
    @nodes << element
  end

end