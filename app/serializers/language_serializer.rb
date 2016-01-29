class LanguageSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :name, :full_name
end
