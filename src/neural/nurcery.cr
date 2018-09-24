module Neural
  class Nurcery
    ACTIONS = %i[father mother average]

    def call(father : Network, mother : Network) : Network
      nodes = father.nodes.map_with_index do |nodes, k|
        nodes.map_with_index do |node, i|
          f_node = father.nodes[k][i, 0].not_nil!
          m_node = mother.nodes[k][i, 0].not_nil!
          case action
          when :father then f_node
          when :mother then m_node
          when :average then (f_node + m_node) / 2
          end.not_nil!
        end
      end

      links = father.links.map_with_index do |links, k|
        LA::GMat.new(*links.size) do |i, j|
          f_link = father.links[k][i, j].not_nil!
          m_link = mother.links[k][i, j].not_nil!
          case action
          when :father then f_link
          when :mother then m_link
          when :average then (f_link + m_link) / 2
          end.not_nil!
        end
      end

      Network.new(nodes, links)
    end

    private def action
      ACTIONS.sample
    end
  end
end
