require 'spec_helper'

describe ImportsController do

  describe "Uploading a file for import" do
    # todo: evaluate whether this spec carries its weight

    let(:sample_file_path) { Rails.root.join('spec', 'fixtures', 'example_input.tab') }
    let(:file)             { fixture_file_upload(sample_file_path) }
    let(:content)          { File.read(sample_file_path) }

    it "accepts a file upload" do
      SalesImporter.any_instance.should_receive(:import).with(content)
      post :create, file: file
      response.should be_success
    end
  end

end
