require "spec_helper"

describe Admin::DocumentsController do
  describe "routing" do

    it "routes to #show" do
      get("/admin/documents/1").should route_to("admin/documents#show", id: "1")
    end

    it "routes to publish document" do
      get("/admin/documents/1/publish").should route_to("admin/documents#publish", id: "1")
    end





  end
end
