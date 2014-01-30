require 'csv'

class SalesImporter

  class ImportSummary
    attr_accessor :record_count, :gross_revenue

    def initialize
      @record_count = 0
      @gross_revenue = Money.new(0)
    end

    def <<(sale_total)
      self.record_count += 1
      self.gross_revenue += sale_total
    end
  end

  def self.import(io)
    summary = ImportSummary.new
    CSV.new(io, col_sep: "\t", headers: true).each do |row|
      purchaser = Purchaser.find_or_create_by!(name: row['purchaser name'])
      merchant = Merchant.find_or_create_by!(name: row['merchant name'], address: row['merchant address'])
      item = Item.find_or_create_by!(description: row['item description'])
      sale = Sale.create!(
        purchaser: purchaser,
        merchant: merchant,
        item: item,
        price: row['item price'],
        count: row['purchase count']
      )
      summary << sale.total
    end
    summary
  end

end
