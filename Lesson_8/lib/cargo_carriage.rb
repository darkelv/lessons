class CargoCarriage < Carriage
  def initialize(spots)
    super('cargo', spots)
  end

  def take_spots(spots_count)
    super(spots_count)
  end
end
