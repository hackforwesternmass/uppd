require 'spec_helper'

describe "filings/show" do
  before(:each) do
    @filing = assign(:filing, stub_model(Filing))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
