require "spec_helper"

describe FilingDocsController do
  describe "routing" do

    it "routes to #index" do
      get("/filing_docs").should route_to("filing_docs#index")
    end

    it "routes to #new" do
      get("/filing_docs/new").should route_to("filing_docs#new")
    end

    it "routes to #show" do
      get("/filing_docs/1").should route_to("filing_docs#show", :id => "1")
    end

    it "routes to #edit" do
      get("/filing_docs/1/edit").should route_to("filing_docs#edit", :id => "1")
    end

    it "routes to #create" do
      post("/filing_docs").should route_to("filing_docs#create")
    end

    it "routes to #update" do
      put("/filing_docs/1").should route_to("filing_docs#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/filing_docs/1").should route_to("filing_docs#destroy", :id => "1")
    end

  end
end
