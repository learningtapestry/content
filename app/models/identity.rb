class Identity < ActiveRecord::Base
  include Indexable
  include Reconcilable
  include Reviewable

  acts_as_indexed

  has_many :document_identities
  has_many :documents, through: :document_identities
end
