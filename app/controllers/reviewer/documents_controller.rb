class Reviewer::DocumentsController < BaseController

  before_action :authorize_reviewer!
  before_action :set_document, only: [:show,  :send_for_rework, :send_for_publication]
  load_and_authorize_resource

  def index
    @documents = Document.all
  end

  def show

     @document.comments.build(user_id: current_user.id)
  end

  def send_for_rework

    respond_to do |format|
      if @document.send_for_rework(document_params)
        format.html { redirect_to reviewer_documents_url, notice: 'Document was successfully commented and sent for rework' }
        format.json { head :no_content }
      else
        format.html { render :show }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  def send_for_publication
    if @document.send_for_publication
      respond_to do |format|
        format.html { redirect_to reviewer_documents_url, notice: 'Document was successfully reviewed and sent for publication' }
        format.json { head :no_content }
      end
    end
  end

  private

    def authorize_reviewer!
      redirect_to root_path, alert: "You are not authorized to access this page." unless current_user.has_role? :reviewer
    end

    def set_document
      @document = Document.find(params[:id])
    end



    def document_params
      params.require(:document).permit!

    end
end
