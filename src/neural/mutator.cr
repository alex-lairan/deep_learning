module Neural
  class Mutator
    def call(network : Network)
      network.nodes.map! do |nodes|
        nodes.map { |node| mutate(node) }
      end

      network.links.map! do |links|
        links.map { |link| mutate(link) }
      end

      network
    end

    private def mutate(e)
      if rand(0..100) < 5
        e += random_value
        e > 0 ? [e, 1].min : [e, -1].max
      else
        e
      end
    end

    private def random_value
      rand(-0.5..0.5)
    end
  end
end
