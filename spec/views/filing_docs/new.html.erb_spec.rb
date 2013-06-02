require 'spec_helper'

describe "filing_docs/new" do
  before(:each) do
    assign(:filing_doc, stub_model(FilingDoc).as_new_record)
  end

  it "renders new filing_doc form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", filing_docs_path, "post" do
    end
  end
end
