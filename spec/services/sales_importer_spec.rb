require 'spec_helper'

describe SalesImporter do

  it 'accepts an IO stream and returns a results object' do
    result = SalesImporter.import(StringIO.new(''))
    expect(result.record_count).to eq(0)
    expect(result.gross_revenue).to eq(0)
  end

  it 'parses a tab delimited string' do
    input = StringIO.new("item price\tpurchase count\n10.0\t2")
    result = SalesImporter.import(input)
    expect(result.record_count).to eq(1)
    expect(result.gross_revenue).to eq(20.0)
  end
end
