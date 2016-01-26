class DocumentIndexedSerializer < ActiveModel::Serializer
  self.root = false

  class GradeSerializer < ActiveModel::Serializer
    attributes :id, :name
  end

  class DocumentIdentitySerializer < ActiveModel::Serializer
    attributes :id, :name, :type

    def id
      object.identity.id
    end

    def name
      object.identity.name
    end

    def type
      object.identity_type.value
    end
  end

  class LanguageSerializer < ActiveModel::Serializer
    attributes :id, :name
  end

  class ResourceTypeSerializer < ActiveModel::Serializer
    attributes :id, :name
  end

  class StandardSerializer < ActiveModel::Serializer
    attributes :id, :name
  end

  class SubjectSerializer < ActiveModel::Serializer
    attributes :id, :name
  end

  attributes :id, :title, :description

  has_many :grades,              serializer: GradeSerializer
  has_many :document_identities, serializer: DocumentIdentitySerializer, root: :identities
  has_many :languages,           serializer: LanguageSerializer
  has_many :resource_types,      serializer: ResourceTypeSerializer
  has_many :standards,           serializer: StandardSerializer
  has_many :subjects,            serializer: SubjectSerializer

  has_one  :document_status, key: :status

  def document_status
    object.document_status.value
  end
end
