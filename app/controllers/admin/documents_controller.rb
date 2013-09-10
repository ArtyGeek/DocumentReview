class Admin::DocumentsController < Admin::AdminController
  before_action :set_admin_document, only: [:show, :publish]

  def show
  end

  def publish
    respond_to do |format|
      if @document.publish
        format.html { redirect_to admin_dashboard_path, notice: 'Document was successfully published' }
        format.json { head :no_content }
      else
        format.html { redirect_to admin_dashboard_path}
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def set_admin_document
      @document = Document.find(params[:id])
    end


end
