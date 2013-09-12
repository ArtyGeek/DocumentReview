require 'spec_helper'

describe "Admin::Documents" do
  describe "GET /admin_documents" do
    it "works! (now write some real specs)" do

      get admin_documents_path
      response.status.should be(200)
    end
  end
end
