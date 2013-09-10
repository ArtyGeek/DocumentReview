class HomeController < ApplicationController

  def index
    @documents = Document.published
  end

   def show
    @document = Document.find(params[:id])
  end
end
