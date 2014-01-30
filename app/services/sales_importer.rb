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
    CSV.parse(io, col_sep: "\t", headers: true) do |row|
      sale = Sale.new(
        price: row['item price'],
        count: row['purchase count']
      )
      summary << sale.total
    end
    summary
  end

end
