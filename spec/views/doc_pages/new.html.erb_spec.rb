require 'spec_helper'

describe "doc_pages/new" do
  before(:each) do
    assign(:doc_page, stub_model(DocPage).as_new_record)
  end

  it "renders new doc_page form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", doc_pages_path, "post" do
    end
  end
end
