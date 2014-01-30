class CreateImports < ActiveRecord::Migration
  def change
    create_table :imports do |t|
      t.integer :record_count,        default: 0
      t.integer :gross_revenue_cents, default: 0
      t.boolean :completed,           default: false

      t.timestamps
    end
  end
end
