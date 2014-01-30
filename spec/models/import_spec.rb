require 'spec_helper'

describe Import do

  # also see related specs in spec/services/sales_importer_spec

  it 'should initialize with starting values' do
    import = Import.new
    expect(import.completed).to eql(false)
    expect(import.record_count).to eq(0)
    expect(import.gross_revenue).to eq(0)
  end

end
