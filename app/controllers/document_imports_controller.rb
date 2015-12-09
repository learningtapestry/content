class DocumentImportsController < ApplicationController
  before_action :set_document_import, only: [:show, :edit, :destroy]

  def index
    @document_imports = DocumentImport.all
  end

  def show
    redirect_to [@document_import, :document_import_rows]
  end

  def new
    @document_import = DocumentImport.new
  end

  def edit
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
    
  end

  private
    def set_document_import
      @document_import = DocumentImport.find(params[:id])
    end

    def document_import_params
      params.require(:document_import).permit(:file, :repository_id)
    end
end
