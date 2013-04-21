require "spec_helper"

describe BracketsController do
  describe "routing" do

    it "routes to #index" do
      get("/brackets").should route_to("brackets#index")
    end

    it "routes to #new" do
      get("/brackets/new").should route_to("brackets#new")
    end

    it "routes to #show" do
      get("/brackets/1").should route_to("brackets#show", :id => "1")
    end

    it "routes to #edit" do
      get("/brackets/1/edit").should route_to("brackets#edit", :id => "1")
    end

    it "routes to #create" do
      post("/brackets").should route_to("brackets#create")
    end

    it "routes to #update" do
      put("/brackets/1").should route_to("brackets#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/brackets/1").should route_to("brackets#destroy", :id => "1")
    end

  end
end
