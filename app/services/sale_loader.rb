require 'csv'

class SaleLoader

  def load(data)
    # todo: error handling - need some way to store and skip failing datas
    # todo: benchmark, consider raw insert
    Sale.transaction do
      purchaser = find_or_create_purchaser(data)
      merchant = find_or_create_merchant(data)
      item = find_or_create_item(data)
      Sale.create!(data[:sale].merge({
        purchaser: purchaser,
        merchant: merchant,
        item: item
      }))
    end
  end

  private

    def find_or_create_purchaser(data)
      Purchaser.find_or_create_by!(data[:purchaser])
    end

    def find_or_create_merchant(data)
      # todo: find only by name and update address?
      Merchant.find_or_create_by!(data[:merchant])
    end

    def find_or_create_item(data)
      Item.find_or_create_by!(data[:item])
    end
end
