require "./network"

module Neural
  class CostCalculator
    def initialize(@network : Network)
    end

    def call(image : LA::GMat, label : UInt8)
      results = @network.call(image)

      results.map_with_index do |value, i|
        penality = (i == label ? 1 : 0)
        (value - penality)**2
      end.sum
    end
  end
end
