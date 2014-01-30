require 'spec_helper'

describe SalesImporter do

  # todo:
  #   - rename DefaultValues
  #   - extract row builder
  #   - spec for transaction around each row
  #   - refactor service
  #   - refactor spec

  DefaultValues = {
    purchaser: 'Prchsr',
    description: 'Dscrptn',
    price: '10.0',
    count: '2',
    address: 'Addrss',
    merchant: 'Mrchnt'
  }

  describe 'saves normalized records' do
    subject do
      -> { import(build({})) }
    end

    it { should change(Purchaser.where(name: 'Prchsr'),                   :count).by(1) }
    it { should change(Merchant.where(name: 'Mrchnt', address: 'Addrss'), :count).by(1) }
    it { should change(Item.where(description: 'Dscrptn'),                :count).by(1) }
    it { should change(Sale,                                              :count).by(1) }
  end

  describe 'checks for existing matching records' do
    before do
      import(build({ purchaser: 'p', description: 'd', merchant: 'm' }))
    end

    it 'uses existing Purchaser with the same name' do
      expect { import(build({ purchaser: 'p' })) }.not_to change(Purchaser, :count)
    end

    it 'connects the existing Purchaser to the Sale' do
      expect { import(build({ purchaser: 'p' })) }
        .to change(Sale.where(purchaser: Purchaser.find_by(name: 'p')), :count)
    end

    it 'uses existing Merchant with the same name' do
      expect { import(build({ merchant: 'm' })) }.not_to change(Merchant, :count)
    end

    it 'connects the existing Merchant to the Sale' do
      expect { import(build({ merchant: 'm' })) }
        .to change(Sale.where(merchant: Merchant.find_by(name: 'm')), :count)
    end

    it 'uses existing Item with the same description' do
      expect { import(build({ description: 'd' })) }.not_to change(Item, :count)
    end

    it 'connects the existing Merchant to the Sale' do
      expect { import(build({ description: 'd' })) }
        .to change(Sale.where(item: Item.find_by(description: 'd')), :count)
    end
  end

  describe 'with the sample file' do

    before(:all) do
      # rspec will wrap each example with a transaction and roll it back,
      # but not with before(:all) blocks
      clean_tables  

      # import only once since all the specs are just verifying that it worked correctly
      File.open(Rails.root.join('spec', 'fixtures', 'example_input.tab')) do |file|
        @results = import(file)
      end
    end

    after(:all) do
      clean_tables
    end

    it 'imports the correct number of records' do
      expect(@results.record_count).to eq(4)
    end

    it 'calculates the gross revenue correctly' do
      expect(@results.gross_revenue)
        .to eq((10.0 * 2) + (10.0 * 5) + (5.0 * 1) + (5.0 * 4))
      # these numbers match the prices and counts in each row of example_input.tab
    end

    it 'creates the correct number of records' do
      expect(Purchaser.count).to eq(3)
      expect(Merchant.count ).to eq(3)
      expect(Item.count     ).to eq(3)
      expect(Sale.count     ).to eq(4)
    end

    def clean_tables
      [Sale, Purchaser, Merchant, Item].each do |model|
        model.delete_all
      end
    end
  end

  def build(vals)
    vals = DefaultValues.merge(vals)
    headers = "purchaser name\titem description\titem price\tpurchase count\tmerchant address\tmerchant name\n"
    line = %I(purchaser description price count address merchant).map{|key| vals[key]}.join("\t")
    headers + line
  end

  def import(io)
    SalesImporter.import(io)
  end

end
