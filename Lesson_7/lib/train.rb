class Train
  include Manufacturer
  include Validation
  include InstanceCounter

  attr_accessor :speed, :railway_carriages, :route, :number
  attr_reader :type
  @@trains = {}
  TRAIN_NUMBER_TEMPLATES = /^([а-я0-9]){3}\-*([а-я0-9]){2}$/i
  TYPES = %w(cargo passenger)

  def initialize(number, type)
    @number = number
    @type = type
    @railway_carriages = []
    @speed = 0
    @current_station_index = 0
    validate!
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

  def carriages_info &block
    railway_carriages.each.with_index(1) do |carriage, index|
      block.call(carriage, index)
    end
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
  def validate!
    raise "Номер непраивльный ожидается три символа буквы или цифры, тире или без него, и еще два символа " unless number =~ TRAIN_NUMBER_TEMPLATES
    raise "Неверный типа поезда выберите cargo или passenger" unless TYPES.include?(@type)
    raise "Название поезда должно быть уникальным" if @@trains.keys.include?(number)
  end

  def previous_station
    route.stations[@current_station_index - 1] unless @current_station_index == 0
  end

  def next_station
    route.stations[@current_station_index + 1] unless @current_station_index == route.stations.size - 1
  end
end
