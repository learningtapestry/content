class IdentityType < ActiveRecord::Base
  has_many :document_identities

  include HasValueField
  default_value_method :publisher, :submitter
end
