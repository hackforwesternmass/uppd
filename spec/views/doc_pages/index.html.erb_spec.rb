require 'spec_helper'

describe "doc_pages/index" do
  before(:each) do
    assign(:doc_pages, [
      stub_model(DocPage),
      stub_model(DocPage)
    ])
  end

  it "renders a list of doc_pages" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
