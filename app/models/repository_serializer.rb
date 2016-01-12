class RepositorySerializer < ActiveModel::Serializer
  attributes :id, :name, :public, :document_count
end
