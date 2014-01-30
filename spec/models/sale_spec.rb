require 'spec_helper'
require 'money-rails/test_helpers'

describe Sale do
  include MoneyRails::TestHelpers

  describe 'price' do
    it 'is monetized' do
      expect(monetize(:price_cents)).to be_true
    end

    it 'accepts price as a string with a decimal' do
      sale = Sale.create(price: "12.34")
      expect(sale.price_cents).to eq(1234)
    end
  end

  describe 'validations' do
    %I(purchaser merchant item price count).each do |field|
      it { should validate_presence_of(field) }
    end
  end
end
