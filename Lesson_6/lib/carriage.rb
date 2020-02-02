class Carriage
  include Manufacturer
  include Validation
  TYPES = %w(cargo, passenger)

  attr_reader :type

  def initialize type
    @type = type
    validate!
  end

  def name
    @type
  end

  protected

  def validate!
    raise "Неверный типа вагон выберите cargo или passenger" unless TYPES.include?(type)
  end
end
