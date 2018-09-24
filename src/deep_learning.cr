require "linalg"

require "./mnist/**"
require "./neural/**"

module DeepLearning
  VERSION = "0.1.0"

  # TODO: Put your code here
end

images = File.open("./data/train-images.idx3-ubyte")
labels = File.open("./data/train-labels.idx1-ubyte")

loader = Mnist::Loader.new(images, labels)
data = loader.call

network = Neural::Builder.new([28 * 28, 16, 16, 10]).call(Neural::Builder::RANDOM_VALUE)
image = LA::GMat.new(28 * 28, 1) { |i, _| data.first.image[i] }
pp network.call(image)

calculator = Neural::CostCalculator.new(network)
pp calculator.call(image, data.first.label)

network_father = Neural::Builder.new([2, 2]).call(Neural::Builder::MIN_VALUE)
network_mother = Neural::Builder.new([2, 2]).call(Neural::Builder::MAX_VALUE)
pp Neural::Nurcery.new.call(network_father, network_mother)
