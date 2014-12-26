class GraphNode
  attr_accessor :value
  attr_reader :nodes

  def initialize(value)
    @value = value
    @nodes = []
  end

  def add_edge(other_node)
    @nodes << other_node
  end
end

class MazeSolver
  attr_reader :maze

  def initialize
    @maze = build_maze(ARGV[0])
  end

  def solve
    puts solvable? ? "solvable" : "unsolvable"
  end

  def solvable?
    unexplored = @maze["00"].nodes
    explored = []
    @steps = 0

    until unexplored.empty?
      current_tile = unexplored.shift
      explored.push(current_tile)
      @steps += 1
      return true if @maze[current_tile].value == "*"

      @maze[current_tile].value = "x"
      draw_maze
      @maze[current_tile].nodes.each do |neighboring_tile|
        unexplored.push(neighboring_tile) unless explored.include?(neighboring_tile) || unexplored.include?(neighboring_tile)
      end
    end

    false
  end

  def build_maze(file_name)
    maze_hash = {}

    File.open(file_name, "r").each_line.with_index do |line, y|
      line.chomp.split('').each.with_index do |tile, x|
        maze_hash["#{x}#{y}"] = GraphNode.new(tile)
      end
    end

    populate_neighboring_tiles(maze_hash)
  end

  def populate_neighboring_tiles(maze_hash)
    maze_hash.each do |coord, tile|
      neighboring_coords = get_neighboring_coords(coord)
      neighboring_coords.each do |neighboring_coord|
        tile.nodes << neighboring_coord unless maze_hash[neighboring_coord].value == "#"
      end
    end
  end

  def get_neighboring_coords(coord_string)
    result = []
    x,y = coord_string.chars.map(&:to_i)
    [-1,1].each do |diff|
      potential_x = x + diff
      potential_y = y + diff
      result << "#{potential_x}#{y}" if potential_x <= 9 && potential_x >= 0
      result << "#{x}#{potential_y}" if potential_y <= 4 && potential_y >= 0
    end

    result.reject { |coord| coord == coord_string }
  end

  def draw_maze
    clear_screen
    @maze.each do |coord, tile|
      x,_ = coord.chars.map(&:to_i)
      print tile.value
      print "\n" if x == 9
    end
    sleep 0.15
  end

  def clear_screen
    print "\e[2J\e[f"
  end
end

maze = MazeSolver.new
maze.solve
