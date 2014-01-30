class Import < ActiveRecord::Base

  monetize :gross_revenue_cents

  def <<(sale_total)
    self.record_count += 1
    self.gross_revenue += sale_total
    self
  end

end
