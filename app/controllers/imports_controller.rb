require 'ostruct'
class ImportsController < ApplicationController

  def index
    # todo: implement
  end

  def new
  end

  def create
    @summary = importer.import(params[:file].read)
    flash.now[:notice] = 'Hooray! - The file imported just fine.'
    render :show
  end

  def show
    # todo: implement
    unless @summary
      @summary = OpenStruct.new
      @summary.record_count =  11
      @summary.gross_revenue =  22.0
      @summary.created_at =  DateTime.now
    end
  end

  private

    def importer
      @importer ||= SalesImporter.new
    end
end
