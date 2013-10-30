require 'debugger'
class Puzzle

  attr_accessor :size

  def set_a_variable
    size = 7
    puts self.size
  end


end

puz = Puzzle.new
puz.set_a_variable