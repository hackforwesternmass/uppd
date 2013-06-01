require 'spec_helper'

describe "FilingDocs" do
  describe "GET /filing_docs" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get filing_docs_path
      response.status.should be(200)
    end
  end
end
