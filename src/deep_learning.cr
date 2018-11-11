require "linalg"

require "./mnist/**"
require "./neural/**"
require "./ai/**"

# Load data
images = File.open("./data/train-images.idx3-ubyte")
labels = File.open("./data/train-labels.idx1-ubyte")

loader = Mnist::Loader.new(images, labels)
data = loader.call

# Prepare neural
# 28 * 28 => All pixels
# 16 => Random value
# 16 => Random value
# 10 => 10 numbers (0..9)
builder = Neural::Builder.new([28 * 28, 16, 16, 10])

# Prepare classes for neural genetic
nurcery = Neural::Nurcery.new
mutator = Neural::Mutator.new
calculator = Neural::CostCalculator.new

# Run a kind of AI (here genetic)
ai = AI::Genetic.new(builder, nurcery, mutator, calculator)
ai.call(data)
