require 'spec_helper'

describe "doc_pages/edit" do
  before(:each) do
    @doc_page = assign(:doc_page, stub_model(DocPage))
  end

  it "renders the edit doc_page form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", doc_page_path(@doc_page), "post" do
    end
  end
end
