class ImportsController < ApplicationController

  before_filter :authenticate_user!

  def index
    @imports = Import.recently_completed
    flash.now[:notice] = 'No files have been imported yet' if @imports.empty?
  end

  def new
    @import = Import.new
  end

  def create
    @import = Import.new(import_params)
    if @import.save
      @import.process_file
      flash[:notice] = 'Hooray! - The file imported just fine. Its contents are summarized below'
      redirect_to imports_path
    else
      # todo: create a _form_errors partial so we can just use the errors on the Import object.
      flash.now[:error] = 'Please Choose a File to Import'
      render :new
    end
  end

  private

    def import_params
      params.fetch(:import, {}).permit(:file)
    end

    def importer
      @importer ||= SalesImporter.new
    end
end
