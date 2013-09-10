class BaseController < ApplicationController
  before_action :authenticate_user!

  def get_more_comments
    respond_to do |format|
      format.js {render "shared/more_comments" }
    end
  end

end
