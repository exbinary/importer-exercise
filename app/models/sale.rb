class Sale < ActiveRecord::Base
  belongs_to :purchaser
  belongs_to :merchant
  belongs_to :item
  monetize   :price_cents

  validates :purchaser, :merchant, :item, :price, :count, presence: true
end
