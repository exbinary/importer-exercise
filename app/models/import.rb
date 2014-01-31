class Import < ActiveRecord::Base
  has_attached_file :file
  monetize :gross_revenue_cents
  validates :file, attachment_presence: true

  def self.recently_completed
    where(completed: true).order(created_at: :desc).take(10)
  end

  def process_file
    parser.each_sale(file_path) do |data|
      self << sale_loader.load(data).total
    end
    update!(completed: true)
    self
  end

  def <<(sale_total)
    self.record_count += 1
    self.gross_revenue += sale_total
    self
  end

  def file_path
    self.file.path
  end

  def parser
    @parser ||= ImportFormatParser.new
  end

  def sale_loader
    @sale_loader ||= SaleLoader.new
  end
end
