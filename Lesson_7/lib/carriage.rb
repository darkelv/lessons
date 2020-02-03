class Carriage
  include Manufacturer
  include Validation
  TYPES = %w(cargo passenger)
  @@carriages = {}
  @@carriages_count = 0
  attr_reader :type, :spots, :reserved_spots

  def initialize type, spots
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
    return "Недостаточно свободных мест" if avalibale_spots < spot_count
    @reserved_spots += spot_count
  end

  def name
    @@carriages_count.key(self)
  end

  protected

  def validate!
    raise "Неверный типа вагон выберите cargo или passenger" unless TYPES.include?(type)
  end
end
