class DocumentImportPrepareWorker
  include Sidekiq::Worker

  def perform(document_import_id)
    document_import = DocumentImport.find(document_import_id)

    return unless document_import.can_prepare?

    document_import.update_attributes(prepare_jid: jid)
    document_import.prepare_import
    DocumentImportMappingsWorker.perform_async(document_import_id)
  end
end
