require 'ostruct'
class ImportsController < ApplicationController

  before_filter :authenticate_user!

  def index
    @imports = Import.where(completed: true).order(created_at: :desc).take(10)
    flash.now[:notice] = 'No files have been imported yet' if @imports.empty?
  end

  def new
  end

  def create
    # todo: this needs cleaning up, but wait for backgrounding feature.
    if params[:file]
      @import = importer.import(params[:file].read)
      flash[:notice] = 'Hooray! - The file imported just fine. Its contents are summarized below'
      redirect_to imports_path
    else
      flash.now[:error] = 'Please Choose a File to import'
      render :new
    end
  end

  def show
    # todo: implement
  end

  private

    def importer
      @importer ||= SalesImporter.new
    end
end
