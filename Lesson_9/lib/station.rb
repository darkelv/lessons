class Station
  include Validation
  include InstanceCounter

  attr_reader :trains, :name

  validate :name, :type, String
  validate :name, :presence

  @@stations = {}

  def initialize(name)
    @name = name
    @trains = []
    validate!
    register_instance
    @@stations[name] = self
  end

  def accept_train(train)
    @trains << train
  end

  def train_info
    trains.each do |train|
      yield train
    end
  end

  def send_train(train)
    trains.delete(train)
  end

  def self.all
    @@stations
  end

  def show_trains(type)
    trains.select { |train| train.type == type }
  end
end
