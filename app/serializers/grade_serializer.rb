class GradeSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :name
end
