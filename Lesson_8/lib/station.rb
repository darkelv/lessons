class Station
  include Validation
  include InstanceCounter

  attr_reader :trains, :name
  @@stations = {}

  def initialize(name)
    @name = name
    @trains = []
    register_instance
    validate!
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

  protected

  def validate!
    raise 'Название слишком короткое' if name.length < 3
    raise 'Название станции должно быть уникальным' if @@stations.keys.include?(name)
  end
end
