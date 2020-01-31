class Station
  attr_reader :trains, :name
  @@stations = []
  def initialize(name)
    @name = name
    @trains = []
    @@stations << self
    register_instance
  end

  def accept_train(train)
    @trains << train
  end

  def send_train(train)
    trains.delete(train)
  end

  def self.all
    @@stations
  end

  def show_trains(type)
    trains.select{|train| train.type == type}
  end
end
