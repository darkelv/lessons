class Carriage
  include Manufacturer
  include Validation
  extend Accessors

  TYPES = %w[cargo passenger]

  attr_reader :type, :spots, :reserved_spots
  attr_accessor_with_history :color
  validate :type, TYPES

  @@carriages = {}
  @@carriages_count = 0

  def initialize(type, spots)
    @type = type
    @spots = spots
    @reserved_spots = 0
    validate!
    @@carriages_count += 1
    @@carriages[@@carriages_count] = self
  end

  def avalibale_spots
    spots - reserved_spots
  end

  def take_spots(spot_count = 1)
    return 'Недостаточно свободных мест' if avalibale_spots < spot_count

    @reserved_spots += spot_count
  end

  def name
    @@carriages_count.key(self)
  end
end
