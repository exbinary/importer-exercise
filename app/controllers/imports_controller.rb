class ImportsController < ApplicationController

  before_filter :authenticate_user!

  def index
    @imports = Import.recently_completed
    flash.now[:notice] = 'No files have been imported yet' if @imports.empty?
  end

  def new
    @import = Import.new  # todo: form_for needs this; is there a better way?
  end

  def create
    # todo: the word import is overused - rethink the naming!
    @import = Import.new(import_params)
    if @import.save
      importer.import(@import)
      flash[:notice] = 'Hooray! - The file imported just fine. Its contents are summarized below'
      redirect_to imports_path
    else
      # todo: create a _form_errors partial so we can just use the errors on the Import object.
      flash.now[:error] = 'Please Choose a File to import'
      render :new
    end
  end

  def show
    # todo: implement
  end

  private

    def import_params
      params.fetch(:import, {}).permit(:file)
    end

    def importer
      @importer ||= SalesImporter.new
    end
end
