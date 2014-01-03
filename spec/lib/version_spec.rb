require 'spec_helper'
require 'ronin/version'

describe Ronin do
  it "complies with semantic versioning" do
    Ronin::VERSION.should match(/\d+\.\d+\.\d+[\-[\dA-Za-z\-\.]+]?[\+[\dA-Za-z\-\.]+]?/)
  end
end
