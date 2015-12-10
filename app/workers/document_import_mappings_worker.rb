class DocumentImportMappingsWorker
  include Sidekiq::Worker

  def perform(document_import_id)
    document_import = DocumentImport.find(document_import_id)
    document_import.update_attributes(mappings_jid: jid)
    document_import.create_mappings
  end
end
