class Route
  include Validation
  include InstanceCounter

  attr_reader :stations

  def initialize(first_station, last_station)
    @stations = [first_station, last_station]
    register_instance
    validate!
  end

  def first_station
    stations.first
  end

  def last_station
    stations.last
  end

  def add_station(station)
    stations.insert(-2, station)
  end

  def delete_station(station)
    stations.delete(station) if stations.slice(1...-1).include?(station)
  end

  def name
    "#{stations.first.name} - #{stations.last.name}"
  end

  protected

  def validate!
    raise "Неврный формат станции" unless stations.first.is_a?(Station) || stations.last.is_a?(Station)
    raise "Первая и последняя станция не могут быть одинаковыми" if stations.first == stations.last
  end
end
