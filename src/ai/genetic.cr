module AI
  class Genetic
    def initialize(@builder    : Neural::Builder,
                   @nurcery    : Neural::Nurcery,
                   @mutator    : Neural::Mutator,
                   @calculator : Neural::CostCalculator)
    end

    def call(data : Array(Mnist::Data), pop_size : Int32 = 1000,
             batch_size : Int32 = 10, cost_threshold : Float64 = 0.1)
      max_iteration = data.size / batch_size
      pop = Array.new(pop_size) { @builder.call(Neural::Builder::RANDOM_VALUE) }

      (0..max_iteration).each do |iteration|
        trained_costs = pop.map do |p|
          Array.new(batch_size) do |i|
            sample = data[iteration * batch_size + i]
            image = LA::GMat.new(@builder.levels[0], 1) { |i, _| sample.image[i] }
            @calculator.call(p, image, sample.label)
          end.sum / batch_size
        end

        trained = pop.zip(trained_costs).sort_by { |data| data[1] }

        break if trained.first[1] < cost_threshold

        selected = trained[0..50].sample(20) +
                   trained[50..150].sample(20) +
                   trained[150..300].sample(20) +
                   trained[300..600].sample(20) +
                   trained[600..1000].sample(20)

        pop = 10.times.flat_map do
          selected.map do |trained|
            network1 = trained[0]
            network2 = selected.sample[0]

           @nurcery.call(network1, network2)
          end
        end.to_a

        pop.each do |network|
          @mutator.call(network)
        end
      end

      pop
    end
  end
end
