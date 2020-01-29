class Route
  attr_reader :stations

  def initialize(first_station, last_station)
    @stations = [first_station, last_station]
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
    "#{@stations.first.name} - #{@stations.last.name}"
  end
end
