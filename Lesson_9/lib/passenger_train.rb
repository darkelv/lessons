class PassengerTrain < Train
  include Validation

  validate :number, :format, NUMBER_TEMPLATES

  def initialize(number, type = 'passenger')
    super
  end
end
