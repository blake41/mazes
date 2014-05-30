require_relative 'my_queue.rb'
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
      maze[:entrance_y] = idx if matrix[idx][0]=='→' 
      maze[:exit_y]     = idx if matrix[idx][matrix[0].size-1]=='@' 
    end
  end
 
  # Square to hold an x,y square during maze traversal, with
  # a link back to it's parent.  Links are used after the exit
  # is found to trace exit back to entrance.
  class Sqr < Struct.new(:x, :y, :parent)
  end
 
  class Solver
 
    def initialize(maze,show_progress=false,queue = MyQueue.new)
      @maze = maze
      @show_progress = show_progress
      @queue = queue
      @exit_found = false
    end
 
    def print
      if @show_progress
        puts "State of the queue"
        puts queue.print
        puts "State of the maze"
        @maze[:matrix].each do |line|
          puts line.join
        end
        puts
      end
    end

    # Main BFS algorithm.
    def solve
 
      walk_maze
 
      # Clear all pathway markers
      clear_matrix
 
      paint_correct_path
    end
 
private 

    def walk_maze
      @current_sqr = Sqr.new(@maze[:entrance_x], @maze[:entrance_y], nil)
      
      queue << @current_sqr
      
      while queue_present? && exit_not_found
        @current_sqr = queue.shift  # queue.pop
        if (@current_sqr.x == maze_exit_x && @current_sqr.y == maze_exit_y)
          mark_exit_found
        else
          change_last_visited_node
          set_node_as_head
          print
          mark_last_visited_node
          add_open_neighbors_to_queue
        end
      end
    end

    def paint_correct_path
      if exit_found
        sqr = @current_sqr
        # Repaint solution pathway with markers
        matrix[sqr.y][sqr.x] = '>'
        while sqr.parent
          sqr = sqr.parent
          matrix[sqr.y][sqr.x] = '+'
        end
        puts "Maze solved:\n\n"
        print
      else
        puts 'No exit found'
      end
    end

    def add_open_neighbors_to_queue
      x = @current_sqr.x
      y = @current_sqr.y
      queue << Sqr.new(x+1,y,@current_sqr) if open_square(x+1,y,matrix)
      queue << Sqr.new(x-1,y,@current_sqr) if open_square(x-1,y,matrix)
      queue << Sqr.new(x,y+1,@current_sqr) if open_square(x,y+1,matrix)
      queue << Sqr.new(x,y-1,@current_sqr) if open_square(x,y-1,matrix)
    end

    def open_square(x,y,matrix)
      return false if (x<0 || x>matrix[0].size-1 || y<0 || y>matrix.size-1) 
      return matrix[y][x] == ' ' || matrix[y][x] == "@"
    end
 
    def clear_matrix
      matrix.each_index do |idx|
        matrix[idx] = matrix[idx].join.gsub(/[^#|\s]/i,' ').split(//)
      end
    end

    def matrix
      @maze[:matrix]
    end

    def set_node_as_visited(sqr, mark)
      matrix[sqr.y][sqr.x] = mark
    end

    def set_node_as_head
      set_node_as_visited(@current_sqr, "o")
    end

    def mark_last_visited_node
      @last_visited_node = @current_sqr
    end

    def change_last_visited_node
      unless @last_visited_node.nil?
        set_node_as_visited(@last_visited_node, "+")
      end
    end

    def maze_exit_x
      @maze[:exit_x]
    end

    def maze_exit_y
      @maze[:exit_y]
    end

    def queue
      @queue
    end

    def queue_present?
      queue.present?
    end

    def exit_not_found
      !@exit_found
    end

    def exit_found
      @exit_found
    end

    def mark_exit_found
      @exit_found = true
    end

  end

end

maze = Maze.load('./maze.txt')
maze_solver = Maze::Solver.new(maze,true)
maze_solver.solve