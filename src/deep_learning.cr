require "linalg"

require "./mnist/**"
require "./neural/**"

images = File.open("./data/train-images.idx3-ubyte")
labels = File.open("./data/train-labels.idx1-ubyte")

loader = Mnist::Loader.new(images, labels)
data = loader.call

# network = Neural::Builder.new([28 * 28, 16, 16, 10]).call(Neural::Builder::RANDOM_VALUE)
# image = LA::GMat.new(28 * 28, 1) { |i, _| data.first.image[i] }
# pp network.call(image)
#
# calculator = Neural::CostCalculator.new(network)
# pp calculator.call(image, data.first.label)
#
# network_father = Neural::Builder.new([2, 2]).call(Neural::Builder::MIN_VALUE)
# network_mother = Neural::Builder.new([2, 2]).call(Neural::Builder::MAX_VALUE)
# pp Neural::Nurcery.new.call(network_father, network_mother)
# pp Neural::Mutator.new.call(network_father)


pp "---------------"
COST_THRESHOLD = 0.1
IMAGE_BATCH = 20

max_iteration = data.size / IMAGE_BATCH
builder = Neural::Builder.new([28 * 28, 16, 16, 10])
nurcery = Neural::Nurcery.new
mutator = Neural::Mutator.new
calculator = Neural::CostCalculator.new
pop = Array.new(5000) { builder.call(Neural::Builder::RANDOM_VALUE) }

(0..max_iteration).each do |iteration|
  p "iteration #{iteration}"

  p "Eval start"
  trained_costs = pop.map do |p|
    Array.new(IMAGE_BATCH) do |i|
      sample = data[iteration * IMAGE_BATCH + i]
      image = LA::GMat.new(28 * 28, 1) { |i, _| sample.image[i] }
      calculator.call(p, image, sample.label)
    end.sum / IMAGE_BATCH
  end
  p "Eval end"

  trained = pop.zip(trained_costs).sort_by { |data| data[1] }
  p "Best cost: #{trained.first[1]}"
  break if trained.first[1] < COST_THRESHOLD
  # select
  p "select start"
  selected = trained[0..50].sample(30) +
             trained[50..150].sample(20) +
             trained[150..300].sample(20) +
             trained[300..600].sample(20) +
             trained[600..1000].sample(20) +
             trained[1000..6000].sample(100)
  p "select end"

  p "reproduce start"
  pop = 50.times.flat_map do
    selected.map do |trained|
      network1 = trained[0]
      network2 = selected.sample[0]

      nurcery.call(network1, network2)
    end
  end.to_a
  p "reproduce end"

  # mutate
  p "mutate start"
  pop.each do |network|
    mutator.call(network) # if rand(0..10) < 4
  end
  p "mutate end"

  break if iteration > max_iteration
end

pp pop.first
