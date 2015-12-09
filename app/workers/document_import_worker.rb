class DocumentImportWorker
  include Sidekiq::Worker

  def perform(document_import_id)
    document_import = DocumentImport.find(document_import_id)
    document_import.update_attributes(import_jid: jid)
    document_import.import
  end
end
