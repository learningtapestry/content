class DocumentExportWorker
  include Sidekiq::Worker

  def perform(document_export_id)
    document_export = DocumentExport.find(document_export_id)
    document_export.update_attributes(export_jid: jid)
    document_export.export
  end
end
