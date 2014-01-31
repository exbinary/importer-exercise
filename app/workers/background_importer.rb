class BackgroundImporter
  @queue = :import_queue
  def self.perform(id)
    Import.find(id).process_file
  end
end
