require 'spec_helper'

describe "filing_docs/edit" do
  before(:each) do
    @filing_doc = assign(:filing_doc, stub_model(FilingDoc))
  end

  it "renders the edit filing_doc form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", filing_doc_path(@filing_doc), "post" do
    end
  end
end
