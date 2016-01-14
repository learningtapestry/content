class DocumentImportWorker
  include Sidekiq::Worker

  def perform(document_import_id)
    document_import = DocumentImport.find(document_import_id)
    
    return unless document_import.can_import?
    
    document_import.update_attributes(import_jid: jid)
    document_import.import

    RepositoryIndexAllDocumentsWorker.perform_async(document_import.repository.id)
  end
end
