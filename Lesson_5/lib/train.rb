class Train
  include Manufacturer

  attr_accessor :speed
  attr_reader :route, :railway_carriages, :type
  @@trains = {}

  def initialize(number, type)
    @number = number
    @type = type
    @railway_carriages = []
    @speed = 0
    @current_station_index = 0
    @@trains[number] = self
    register_instance
  end

  def self.find number
    @@trains[number]
  end

  def go
    @speed = 50
  end

  def stop
    @speed = 0
  end

  def name
    @number
  end

  def set_carriage(carriage)
    return puts "Выберите другой тип вагона или остановите поезд" if  type != carriage.type || speed != 0
    railway_carriages << carriage
  end

  def remove_carriage(carriage)
    return puts "Поезд едет или вагоны закончились" if !railway_carriages.include?(carriage) || speed != 0
    railway_carriages.reject! { |wagon| wagon == carriage }
  end

  def set_route(route)
    @route = route
    route.first_station.accept_train(self)
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

  def current_station
    route.stations[@current_station_index]
  end

  protected
  #Эти методы исопльзуются только внтури основного класса и его подклассов

  def previous_station
    route.stations[@current_station_index - 1] unless @current_station_index == 0
  end

  def next_station
    route.stations[@current_station_index + 1] unless @current_station_index == route.stations.size - 1
  end
end
