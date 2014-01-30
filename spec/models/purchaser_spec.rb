require 'spec_helper'

describe Purchaser do
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }
end
