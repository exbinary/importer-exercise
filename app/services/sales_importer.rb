require 'csv'

class SalesImporter

  # @param collector <Import> An Import instance that has already been persisted
  def import(collector)
    # todo: smells of feature envy: maybe this functionality can move to Import?
    CSV.foreach(collector.file_path, col_sep: "\t", headers: true) do |row|
      collector << process(row).total
    end
    collector.update!(completed: true)
    collector
  end

  private

    def process(row)
      # todo: error handling - need some way to store and skip failing rows
      # todo: benchmark, consider raw insert
      Sale.transaction do
        purchaser = find_or_create_purchaser(row)
        merchant = find_or_create_merchant(row)
        item = find_or_create_item(row)
        Sale.create!(
          purchaser: purchaser,
          merchant: merchant,
          item: item,
          price: row['item price'],
          count: row['purchase count']
        )
      end
    end

    def find_or_create_purchaser(row)
      Purchaser.find_or_create_by!(name: row['purchaser name'])
    end

    def find_or_create_merchant(row)
      # todo: find only by name and update address?
      Merchant.find_or_create_by!(
        name: row['merchant name'],
        address: row['merchant address']
      )
    end

    def find_or_create_item(row)
      Item.find_or_create_by!(description: row['item description'])
    end

end
