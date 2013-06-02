require "spec_helper"

describe DocPagesController do
  describe "routing" do

    it "routes to #index" do
      get("/doc_pages").should route_to("doc_pages#index")
    end

    it "routes to #new" do
      get("/doc_pages/new").should route_to("doc_pages#new")
    end

    it "routes to #show" do
      get("/doc_pages/1").should route_to("doc_pages#show", :id => "1")
    end

    it "routes to #edit" do
      get("/doc_pages/1/edit").should route_to("doc_pages#edit", :id => "1")
    end

    it "routes to #create" do
      post("/doc_pages").should route_to("doc_pages#create")
    end

    it "routes to #update" do
      put("/doc_pages/1").should route_to("doc_pages#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/doc_pages/1").should route_to("doc_pages#destroy", :id => "1")
    end

  end
end
