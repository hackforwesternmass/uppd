require 'spec_helper'

describe "proceedings/new" do
  before(:each) do
    assign(:proceeding, stub_model(Proceeding).as_new_record)
  end

  it "renders new proceeding form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", proceedings_path, "post" do
    end
  end
end
