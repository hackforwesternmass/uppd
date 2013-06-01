require 'spec_helper'

describe "doc_pages/show" do
  before(:each) do
    @doc_page = assign(:doc_page, stub_model(DocPage))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
