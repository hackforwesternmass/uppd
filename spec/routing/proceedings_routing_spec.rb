require "spec_helper"

describe ProceedingsController do
  describe "routing" do

    it "routes to #index" do
      get("/proceedings").should route_to("proceedings#index")
    end

    it "routes to #new" do
      get("/proceedings/new").should route_to("proceedings#new")
    end

    it "routes to #show" do
      get("/proceedings/1").should route_to("proceedings#show", :id => "1")
    end

    it "routes to #edit" do
      get("/proceedings/1/edit").should route_to("proceedings#edit", :id => "1")
    end

    it "routes to #create" do
      post("/proceedings").should route_to("proceedings#create")
    end

    it "routes to #update" do
      put("/proceedings/1").should route_to("proceedings#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/proceedings/1").should route_to("proceedings#destroy", :id => "1")
    end

  end
end
