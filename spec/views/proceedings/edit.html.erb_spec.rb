require 'spec_helper'

describe "proceedings/edit" do
  before(:each) do
    @proceeding = assign(:proceeding, stub_model(Proceeding))
  end

  it "renders the edit proceeding form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", proceeding_path(@proceeding), "post" do
    end
  end
end
