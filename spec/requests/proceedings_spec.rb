require 'spec_helper'

describe "Proceedings" do
  describe "GET /proceedings" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get proceedings_path
      response.status.should be(200)
    end
  end
end
