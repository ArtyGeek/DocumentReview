class Author::DocumentsController < BaseController
  before_action :authorize_author!

  before_action :set_author_document, only: [:show, :edit, :update, :destroy, :send_for_review]
  load_and_authorize_resource


  def index
    @author_documents = current_user.documents
  end

  def show
  end

  def new
    @author_document = current_user.documents.new
  end

  def edit
  end

  def create
    @author_document = current_user.documents.new(document_params)

    respond_to do |format|
      if @author_document.save
        format.html { redirect_to author_document_path(@author_document), notice: 'Document was successfully created.' }
        format.json { render action: 'show', status: :created, location: @author_document }
      else
        format.html { render action: 'new' }
        format.json { render json: @author_document.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @author_document.update(document_params)
        format.html { redirect_to author_document_path(@author_document), notice: 'Document was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @author_document.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @author_document.destroy
        format.html { redirect_to author_documents_url, notice: 'Document was successfully destroyed' }
        format.json { head :no_content }
      else
        format.html { redirect_to author_documents_url}
        format.json { render json: @author_document.errors, status: :unprocessable_entity }
      end
    end
  end

    def send_for_review
      respond_to do |format|
        if @author_document.send_for_review
          format.html { redirect_to author_documents_url, notice: 'Document was successfully sent for review' }
          format.json { head :no_content }
        else
          format.html { redirect_to author_documents_url}
          format.json { render json: @author_document.errors, status: :unprocessable_entity }
        end
      end
    end

    private
    def authorize_author!
      redirect_to root_path, alert: "You are not authorized to access this page." unless current_user.has_role? :author
    end

    def set_author_document
      @author_document = current_user.documents.find(params[:id])
    end

    def document_params
      params.require(:document).permit(:id, '_destroy', :title, :description, attachments_attributes: [:file, :id, '_destroy'])
    end
  end
