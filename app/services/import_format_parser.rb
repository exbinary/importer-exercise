require 'csv'

class ImportFormatParser
  def each_sale(path)
    CSV.foreach(path, col_sep: "\t", headers: true) do |row|
      yield ({
        purchaser: { name:        row['purchaser name'] },
        merchant:  { name:        row['merchant name'],
                     address:     row['merchant address'] },
        item:      { description: row['item description'] },
        sale:      { price:       row['item price'],
                     count:       row['purchase count'] }
      })
    end
  end
end
