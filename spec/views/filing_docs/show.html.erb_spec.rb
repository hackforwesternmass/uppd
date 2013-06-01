require 'spec_helper'

describe "filing_docs/show" do
  before(:each) do
    @filing_doc = assign(:filing_doc, stub_model(FilingDoc))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
