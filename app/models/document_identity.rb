class DocumentIdentity < ActiveRecord::Base
  belongs_to :document, touch: true
  belongs_to :identity
  belongs_to :identity_type
end
