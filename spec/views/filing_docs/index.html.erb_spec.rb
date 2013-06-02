require 'spec_helper'

describe "filing_docs/index" do
  before(:each) do
    assign(:filing_docs, [
      stub_model(FilingDoc),
      stub_model(FilingDoc)
    ])
  end

  it "renders a list of filing_docs" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
