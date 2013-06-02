require 'spec_helper'

describe "filings/new" do
  before(:each) do
    assign(:filing, stub_model(Filing).as_new_record)
  end

  it "renders new filing form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", filings_path, "post" do
    end
  end
end
