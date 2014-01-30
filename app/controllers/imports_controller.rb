require 'ostruct'
class ImportsController < ApplicationController

  def index
    # todo: implement
  end

  def new
  end

  def create
    @import = importer.import(params[:file].read)
    flash.now[:notice] = 'Hooray! - The file imported just fine.'
    render :show
  end

  def show
    # todo: implement
    unless @import
      @import = OpenStruct.new
      @import.record_count =  11
      @import.gross_revenue =  22.0
      @import.created_at =  DateTime.now
    end
  end

  private

    def importer
      @importer ||= SalesImporter.new
    end
end
