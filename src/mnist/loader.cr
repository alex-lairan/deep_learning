module Mnist
  IMAGE_IDENTIFIER = 2051
  LABEL_IDENTIFIER = 2049
  ENDIAN           = IO::ByteFormat::BigEndian

  alias Image = Array(UInt8)
  alias Label = UInt8

  struct Data
    getter image, label

    def initialize(@image : Image, @label : Label)
    end
  end

  class LoaderException < Exception
    def initialize(message = "The file doesn't have correct identifier")
      super(message)
    end
  end

  class ImageLoaderException < LoaderException
  end

  class LabelLoaderException < LoaderException
  end

  class MatchingSizeException < LoaderException
    def initialize(message = "Image and Label count doesn't match")
      super(message)
    end
  end

  class Loader
    @max_size : UInt32

    def initialize(@images_io : IO, @labels_io : IO)
      image_id = @images_io.read_bytes(UInt32, ENDIAN)
      raise ImageLoaderException.new unless image_id == IMAGE_IDENTIFIER

      label_id = @labels_io.read_bytes(UInt32, ENDIAN)
      raise LabelLoaderException.new unless label_id == LABEL_IDENTIFIER

      image_count = @images_io.read_bytes(UInt32, ENDIAN)
      label_count = @labels_io.read_bytes(UInt32, ENDIAN)
      raise MatchingSizeException.new unless image_count == label_count

      @max_size = image_count
    end

    def call(wanted_size : UInt32 = @max_size) : Array(Data)
      size = [wanted_size, @max_size].min
      @images_io.seek(8)
      @labels_io.seek(8)

      row_size = @images_io.read_bytes(UInt32, ENDIAN)
      col_size = @images_io.read_bytes(UInt32, ENDIAN)

      image_slice = Bytes.new(row_size * col_size)

      Array.new(size) do |i|
        @images_io.read(image_slice)
        image = image_slice.to_a
        label = @labels_io.read_bytes(UInt8, ENDIAN)

        Data.new(image, label)
      end
    end
  end
end
