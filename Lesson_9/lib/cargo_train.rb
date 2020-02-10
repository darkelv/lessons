class CargoTrain < Train
  include Validation

  validate :number, :format, NUMBER_TEMPLATES

  def initialize(number, type = 'cargo')
    super
  end
end
