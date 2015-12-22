class DocumentsController < ApplicationController
  def index
    @documents = Document.order(id: :asc).page(params[:page] || 1)
  end
end
