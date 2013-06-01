require "spec_helper"

describe FilingsController do
  describe "routing" do

    it "routes to #index" do
      get("/filings").should route_to("filings#index")
    end

    it "routes to #new" do
      get("/filings/new").should route_to("filings#new")
    end

    it "routes to #show" do
      get("/filings/1").should route_to("filings#show", :id => "1")
    end

    it "routes to #edit" do
      get("/filings/1/edit").should route_to("filings#edit", :id => "1")
    end

    it "routes to #create" do
      post("/filings").should route_to("filings#create")
    end

    it "routes to #update" do
      put("/filings/1").should route_to("filings#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/filings/1").should route_to("filings#destroy", :id => "1")
    end

  end
end
