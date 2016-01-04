class DocumentExportsController < AuthenticatedController
  before_action :set_document_export, only: [:show, :destroy, :download]

  CONTENT_TYPES = {
    'csv' => 'text/csv'
  }  

  def index
    @document_exports = DocumentExport.all
  end

  def show
  end

  def new
    @document_export = DocumentExport.new
  end

  def create
    @document_export = DocumentExport.new(document_export_params)

    respond_to do |format|
      if @document_export.save
        DocumentExportWorker.perform_async(@document_export.id)
        format.html { redirect_to @document_export, notice: 'Document export was successfully created.' }
        format.json { render :show, status: :created, location: @document_export }
      else
        format.html { render :new }
        format.json { render json: @document_export.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @document_export.destroy
    respond_to do |format|
      format.html { redirect_to document_exports_url, notice: 'Document export was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def download
    if @document_export.exported?
      send_file(@document_export.file,
        type: CONTENT_TYPES[@document_export.export_type],
        disposition: :attachment
      )
    end
  end

  private
    def set_document_export
      @document_export = DocumentExport.find(params[:id])
    end

    def document_export_params
      params
        .require(:document_export)
        .permit(:repository_id, :export_type, :filtered_ids)
    end
end
