class Language < ActiveRecord::Base
  include Indexable
  include Reconcilable

  acts_as_indexed

  belongs_to :review_status

  has_many :document_languages
  has_many :documents, through: :document_languages
end
