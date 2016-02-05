class StandardSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :name, :url, :standard_framework_id
end
