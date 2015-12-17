json.array!(@document_exports) do |document_export|
  json.extract! document_export, :id, :export_jid, :exported_at, :repository_id, :file, :export_type, :filtered_ids
  json.url document_export_url(document_export, format: :json)
end
