class Train
  attr_accessor :speed
  attr_reader :railway_carriages, :type, :route


  def initialize(number, type, railway_carriages)
    @number = number
    @type = type
    @railway_carriages = railway_carriages
    @speed = 0
    @current_station_index = 0
  end

  def go
    speed = 50
  end

  def stop
    speed = 0
  end

  def set_carriages
    return puts "Поезд едет прицепить вагон невозможно" if speed > 0
    @railway_carriages += 1
  end

  def remove_carriages
    return puts "Поезд едет или вагоны закончились" if speed > 0 && @railway_carriages == 0
    @railway_carriages -= 1
  end

  def set_route(route)
    @route = route
    route.first_station.accept_train(self)
  end

  def current_station
    route.stations[@current_station_index]
  end

  def previous_station
    route.stations[@current_station_index - 1] unless @current_station_index == 0
  end

  def next_station
    route.stations[@current_station_index + 1] unless @current_station_index == route.stations.size - 1
  end

  def move_next_station
    if next_station
      current_station.send_train(self)
      next_station.accept_train(self)
      @current_station_index += 1
    end
  end

  def move_previous_station
    if previous_station
      current_station.send_train(self)
      previous_station.accept_train(self)
      @current_station_index -= 1
    end
  end
end
