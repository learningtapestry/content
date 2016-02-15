class StandardSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :name, :url, :description, :standard_framework_id, :definitions
end
