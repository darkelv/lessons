module Manufacturer
  include Validation

  attr_accessor :manufacturer

  def initialize manufacturer
    @manufacturer = manufacturer
  end
end
