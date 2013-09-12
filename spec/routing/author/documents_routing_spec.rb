require "spec_helper"

describe Author::DocumentsController do
  describe "routing" do

    it "routes to #index" do
      get("/author/documents").should route_to("author/documents#index")
    end

    it "routes to #new" do
      get("/author/documents/new").should route_to("author/documents#new")
    end

    it "routes to #show" do
      get("/author/documents/1").should route_to("author/documents#show", id: "1")
    end

    it "routes to #edit" do
      get("/author/documents/1/edit").should route_to("author/documents#edit", id: "1")
    end

    it "routes to #create" do
      post("/author/documents").should route_to("author/documents#create")
    end

    it "routes to #update" do
      put("/author/documents/1").should route_to("author/documents#update", id: "1")
    end

    it "routes to #destroy" do
      delete("/author/documents/1").should route_to("author/documents#destroy", id: "1")
    end

    it "routes to #send_for_review" do
      get("/author/documents/1/send_for_review").should route_to("author/documents#send_for_review", id: "1")
    end

  end
end
