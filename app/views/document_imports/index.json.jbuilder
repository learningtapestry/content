json.array!(@document_imports) do |document_import|
  json.extract! document_import, :id
  json.url document_import_url(document_import, format: :json)
end
