class DocumentsController < ApplicationController
  def index
    @documents = Document.all
  end
end
