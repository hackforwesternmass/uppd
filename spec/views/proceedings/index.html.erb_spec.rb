require 'spec_helper'

describe "proceedings/index" do
  before(:each) do
    assign(:proceedings, [
      stub_model(Proceeding),
      stub_model(Proceeding)
    ])
  end

  it "renders a list of proceedings" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
