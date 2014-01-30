require 'spec_helper'
require 'database_cleaner'

describe SalesImporter do

  HeaderRow = "purchaser name\titem description\titem price\tpurchase count\tmerchant address\tmerchant name"
  SampleValues = {
    purchaser: 'Prchsr',
    description: 'Dscrptn',
    price: '10.0',
    count: '2',
    address: 'Addrss',
    merchant: 'Mrchnt'
  }

  let!(:sales_importer) { SalesImporter.new }

  describe 'saves normalized records' do
    subject do
      -> { import(SampleValues) }
    end

    it { should change(Purchaser.where(name: 'Prchsr'),                   :count).by(1) }
    it { should change(Merchant.where(name: 'Mrchnt', address: 'Addrss'), :count).by(1) }
    it { should change(Item.where(description: 'Dscrptn'),                :count).by(1) }
    it { should change(Sale,                                              :count).by(1) }
  end

  describe 'checks for existing matching records' do
    before do
      import(purchaser: 'p', description: 'd', merchant: 'm')
    end

    it 'uses existing Purchaser with the same name' do
      expect { import(purchaser: 'p') }.not_to change(Purchaser, :count)
    end

    it 'connects existing Purchaser to the Sale' do
      expect { import(purchaser: 'p') }
        .to change(Sale.where(purchaser: Purchaser.find_by(name: 'p')), :count)
    end

    it 'uses existing Merchant with the same name' do
      expect { import(merchant: 'm') }.not_to change(Merchant, :count)
    end

    it 'connects existing Merchant to the Sale' do
      expect { import(merchant: 'm') }
        .to change(Sale.where(merchant: Merchant.find_by(name: 'm')), :count)
    end

    it 'uses existing Item with the same description' do
      expect { import(description: 'd') }.not_to change(Item, :count)
    end

    it 'connects existing Merchant to the Sale' do
      expect { import(description: 'd') }
        .to change(Sale.where(item: Item.find_by(description: 'd')), :count)
    end
  end

  describe 'with the sample file' do

    before(:all) do
      # import only once since all the specs are just verifying that it worked correctly
      File.open(Rails.root.join('spec', 'fixtures', 'example_input.tab')) do |file|
        @results = SalesImporter.new.import(file) # using sales_importer causes rspec warnings...
      end
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
      expect(Import.count   ).to eq(1)
    end

    it 'marks the Import as completed' do
      expect(@results).to be_completed
    end

  end

  describe 'atomicity', truncate: true do
    # note: the truncate flag above ensures this spec isn't run inside a transaction: see spec_helper

    before do
      begin
        import(price: 'NaN')
      rescue ActiveRecord::RecordInvalid => e
        @error = e
      end
    end

    it 'raises an error when a record is invalid' do
      # todo: add ability to skip bad record
      expect(@error.record.errors[:price]).to have(1).error
    end

    [Purchaser, Merchant, Item, Sale].each do |model|
      it "rolls back #{model} if an error occurs" do
        expect(model.count).to eq(0)
      end
    end

    it 'saves an Import object marked incomplete' do
      expect(Import.count).to eq(1)
      expect(Import.first).not_to be_completed
    end
  end

  def import(fields)
    sales_importer.import(build_row_with_headers(SampleValues.merge(fields)))
  end

  def build_row_with_headers(fields)
    row = %I(purchaser description price count address merchant).map{|key| fields[key]}.join("\t")
    "#{HeaderRow}\n#{row}\n"
  end

end
