module Neural
  class Network
    getter nodes, links

    def initialize(@nodes : Array(LA::GMat), @links : Array(LA::GMat))
    end

    def call(image : LA::GMat)
      vector_for(@nodes.size - 1, image)
    end

    private def vector_for(x : Int32, image : LA::GMat)
      if x == 0
        bias = @nodes[x]
        matrix = image
        matrix_sigmoid(matrix + bias)
      else
        matrix = @links[x - 1]
        bias = @nodes[x]

        matrix_sigmoid(matrix * vector_for(x - 1, image) + bias)
      end
    end

    private def sigmoid(x)
      1 / (1 + Math.exp(-x))
    end

    private def matrix_sigmoid(matrix)
      matrix.map { |val| sigmoid(val) }
    end
  end
end
