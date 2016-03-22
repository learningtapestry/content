GrapeSwaggerRails.options.url = '/swagger_doc'
GrapeSwaggerRails.options.app_url = "#{ENV.fetch('API_URL', 'http://localhost:3000/api/v1')}"
GrapeSwaggerRails.options.api_auth = 'basic'
GrapeSwaggerRails.options.api_key_name = 'X-Api-Key'
GrapeSwaggerRails.options.api_key_type = 'header'
