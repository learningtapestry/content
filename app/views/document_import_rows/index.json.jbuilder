json.array!(@document_import_rows) do |document_import_row|
  json.extract! document_import_row, :id
  json.url document_import_row_url(document_import_row, format: :json)
end
