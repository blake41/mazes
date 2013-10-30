require 'debugger'
module Maze 
 def self.load(file) 
    maze = {}
    matrix = []
    File.open(file) do |file|
      # line_no = 1
      file.each_line do |line|
        # puts line_no
        # puts line
        # line_no += 1
        matrix << line.chomp.split(//)
      end
    end
    maze[:matrix] = matrix
    set_entry_exit(maze)
    maze
  end
 
  def self.set_entry_exit(maze)
    matrix = maze[:matrix]
    maze[:entrance_x] = 0
    maze[:exit_x]     = matrix[0].size-1
    matrix.each_index do |idx|
      maze[:entrance_y] = idx if matrix[idx][0]==' ' 
      maze[:exit_y]     = idx if matrix[idx][matrix[0].size-1]==' ' 
    end
    err = <<-ERROR 
      Exits must be on the left and right side of the maze
    ERROR
    raise err unless maze.size == 5
  end
 
  # Square to hold an x,y square during maze traversal, with
  # a link back to it's parent.  Links are used after the exit
  # is found to trace exit back to entrance.
  class Sqr < Struct.new(:x, :y, :parent)
  end
 
  class Solver
 
    def initialize(maze,show_progress=false)
      @maze = maze
      @show_progress = show_progress
      @queue = []
    end
 
    def print
      @maze[:matrix].each do |line|
        puts line.join
      end
      puts
    end

    # Main BFS algorithm.
    def solve
      matrix = @maze[:matrix]
      exit_found = false
 
      sqr = Sqr.new(@maze[:entrance_x], @maze[:entrance_y], nil)
 
      queue << sqr
 
      while queue_present? && exit_not_found
        sqr = queue.shift  # queue.pop
        x = sqr.x
        y = sqr.y
        if (x == @maze[:exit_x] && y == @maze[:exit_y])
          exit_found = true
        else
          matrix[y][x] = '-'  # Mark path as visited
          print if @show_progress
          queue << Sqr.new(x+1,y,sqr) if open_square(x+1,y,matrix)
          queue << Sqr.new(x-1,y,sqr) if open_square(x-1,y,matrix)
          queue << Sqr.new(x,y+1,sqr) if open_square(x,y+1,matrix)
          queue << Sqr.new(x,y-1,sqr) if open_square(x,y-1,matrix)
        end
      end
 
      # Clear all pathway markers
      clear_matrix
 
      if exit_found
        # Repaint solution pathway with markers
        matrix[sqr.y][sqr.x] = '>'
        while sqr.parent
          sqr = sqr.parent
          matrix[sqr.y][sqr.x] = '-'
        end
        puts "Maze solved:\n\n"
        print
        else
          puts 'No exit found'
      end
    end
 
    private 
 
    def open_square(x,y,matrix)
      return false if (x<0 || x>matrix[0].size-1 || y<0 || y>matrix.size-1) 
      return matrix[y][x] == ' '
    end
 
    def clear_matrix
      @maze[:matrix].each_index do |idx|
        @maze[:matrix][idx] = @maze[:matrix][idx].join.gsub(/[^#|\s]/i,' ').split(//)
      end
    end

    def queue
      @queue
    end

    def queue_present?
      !@queue.empty?
    end

    def queue_full
      
    end

    def exit_not_found
      !@exit_found
    end
    
    def exit_found
      @exit_found
    end
  end
 
end

maze = Maze.load('./maze.txt')
maze_solver = Maze::Solver.new(maze,true)
maze_solver.solve