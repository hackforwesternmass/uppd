require 'spec_helper'

describe "filings/edit" do
  before(:each) do
    @filing = assign(:filing, stub_model(Filing))
  end

  it "renders the edit filing form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", filing_path(@filing), "post" do
    end
  end
end
