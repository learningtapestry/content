class DocumentImportRowsController < ApplicationController
  before_action :set_document_import_row, only: [:show, :edit, :update, :destroy]
  before_action :set_document_import

  def show
  end

  def create
    @document_import_row = DocumentImportRow.new(document_import_row_params)

    respond_to do |format|
      if @document_import_row.save
        format.html { redirect_to @document_import_row, notice: 'Csv document import row was successfully created.' }
        format.json { render :show, status: :created, location: @document_import_row }
      else
        format.html { render :new }
        format.json { render json: @document_import_row.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @document_import_row.update(document_import_row_params)
        format.html { redirect_to @document_import_row, notice: 'Csv document import row was successfully updated.' }
        format.json { render :show, status: :ok, location: @document_import_row }
      else
        format.html { render :edit }
        format.json { render json: @document_import_row.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @document_import_row.destroy
    respond_to do |format|
      format.html { redirect_to document_import_rows_url, notice: 'Csv document import row was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_document_import
      @document_import = DocumentImport.find(params[:document_import_id])
    end

    def set_document_import_row
      @document_import_row = DocumentImportRow.find(params[:id])
    end

    def document_import_row_params
      params[:document_import_row]
    end
end
