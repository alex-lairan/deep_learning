require "./network"

module Neural
  class Builder
    DEFAULT_VALUE = Proc(Float64).new { 0.0 }
    RANDOM_VALUE  = Proc(Float64).new { rand(-1.0..1.0) }

    def initialize(@levels : Array(Int32))
    end

    def call(default_value = DEFAULT_VALUE) : Network
      nodes = Array.new(@levels.size) do |i|
        LA::GMat.new(@levels[i], 1) { default_value.call }
      end

      links = Array.new(@levels.size - 1) do |i|
        LA::GMat.new(@levels[i + 1], @levels[i]) { default_value.call }
      end

      Network.new(nodes, links)
    end
  end
end
