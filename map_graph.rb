require 'rgl/adjacency'
require 'rgl/dot'
require 'rgl/traversal'

class MapGraph

	def initialize()
    @downtown = RGL::DirectedAdjacencyGraph.new
    @num_road = 0
    @num_crossroad = 0
	end

	#write the graph to file graph.dot using dotty to view.
	def write()
    
    #@downtown.dotty(graph_params)
    @downtown.write_to_graphic_file('dot')
 	end

	#show all the vertices and edges
	def show()
    puts @downtown.vertices
    puts @downtown.edges
    graph_params = {
      'fontsize' => '14',
      'bgcolor' => 'grey',
    }
    @downtown.dotty(graph_params)
	end

	#return the roads of this Map
	def roads()
    @downtown.edges
	end

	#return the crossroads of this Map
	def crossroads()
    @downtown.vertices
	end

	#add roads into this Map
	def add_road(u, v)
    @downtown.add_edge(u, v)
    @num_road = @num_road + 1
	end

	#add crossroads into this Map
	def add_crossroad(v)
    @downtown.add_crossroad(v)
    @num_crossroad = @num_crossroad + 1
	end

	#remove roads from this Map
	def remove_road(u, v)
    @downtown.remove_edge(u, v)
    @num_road = @num_road - 1
	end

	#remove crossroads from this Map
	def remove_crossroad(v)
    @downtown.remove_vertex(v)
    @num_crossroad = @num_crossroad - 1
	end

	def bfs_iterator(v)
    @downtown.bfs_iterator(v)
	end
  
  def graph_from_dotfile (file)
    @downtown = RGL::AdjacencyGraph.new
    pattern = /\s*([^\"]+)[\"\s]*--[\"\s]*([^\"\[\;]+)/ # ugly but works
    IO.foreach(file) { |line|
      case line
      when /^digraph/
        @downtown = RGL::DirectedAdjacencyGraph.new
        pattern = /\s*([^\"]+)[\"\s]*->[\"\s]*([^\"\[\;]+)/
      when pattern
        @downtown.add_edge $1,$2
      else
        nil
      end
    }
    g
  end
end
