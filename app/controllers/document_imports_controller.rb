class DocumentImportsController < AuthenticatedController
  before_action :set_document_import, only: [:show, :destroy, :publish]

  def index
    @document_imports = DocumentImport.all
  end

  def show
    @rows = @document_import.rows.order(id: :asc).page(params[:page] || 1)
  end

  def new
    @document_import = DocumentImport.new
  end

  def create
    @document_import = DocumentImport.new(document_import_params)

    respond_to do |format|
      if @document_import.save
        DocumentImportPrepareWorker.perform_async(@document_import.id)
        format.html { redirect_to @document_import, notice: 'Csv document import was successfully created.' }
        format.json { render :show, status: :created, location: @document_import }
      else
        format.html { render :new }
        format.json { render json: @document_import.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @document_import.destroy
    respond_to do |format|
      format.html { redirect_to document_imports_url, notice: 'Csv document import was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def publish
    if @document_import.can_import?
      DocumentImportWorker.perform_async(@document_import.id)
      respond_to do |format|
        format.html { redirect_to @document_import, notice: 'Csv document import is being imported.' }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to @document_import, notice: 'Csv document import can not be imported yet.' }
        format.json { render json: @document_import.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def set_document_import
      @document_import = DocumentImport.find(params[:id])
    end

    def document_import_params
      params.require(:document_import).permit(:file, :repository_id)
    end
end
