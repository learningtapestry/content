json.array!(@repositories) do |repository|
  json.extract! repository, :id, :name, :public
  json.url repository_url(repository, format: :json)
end
