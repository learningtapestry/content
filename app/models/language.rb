class Language < ActiveRecord::Base
  include Indexable
  include Reconcilable
  include Reviewable

  acts_as_indexed

  has_many :document_languages
  has_many :documents, through: :document_languages
end
