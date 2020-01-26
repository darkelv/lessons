class Station
  attr_reader :trains, :station_name

  def initialize(station_name)
    @station_name = station_name
    @trains = []
  end

  def accept_train(train)
    @trains << train
  end

  def send_train(train)
    trains.delete(train)
  end

  def show_trains(type)
    trains.select{|train| train.type == type}
  end
end
