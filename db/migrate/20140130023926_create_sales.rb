class CreateSales < ActiveRecord::Migration
  def change
    create_table :sales do |t|
      t.references :purchaser, index: true
      t.references :merchant, index: true
      t.references :item, index: true
      t.integer :price_cents
      t.integer :count

      t.timestamps
    end
  end
end
