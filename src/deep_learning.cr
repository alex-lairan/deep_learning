require "./mnist/**"

module DeepLearning
  VERSION = "0.1.0"

  # TODO: Put your code here
end

images = File.open("./data/train-images.idx3-ubyte")
labels = File.open("./data/train-labels.idx1-ubyte")

loader = Mnist::Loader.new(images, labels)
data = loader.call
