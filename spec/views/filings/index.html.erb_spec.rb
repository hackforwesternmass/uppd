require 'spec_helper'

describe "filings/index" do
  before(:each) do
    assign(:filings, [
      stub_model(Filing),
      stub_model(Filing)
    ])
  end

  it "renders a list of filings" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
