class DocumentPrepareImportWorker
  include Sidekiq::Worker

  def perform(document_import_id)
    document_import = DocumentImport.find(document_import_id)
    document_import.update_attributes(prepare_jid: jid)
    document_import.prepare_import
  end
end
