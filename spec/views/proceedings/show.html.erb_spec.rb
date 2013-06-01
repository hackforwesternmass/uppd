require 'spec_helper'

describe "proceedings/show" do
  before(:each) do
    @proceeding = assign(:proceeding, stub_model(Proceeding))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
