class Language < ActiveRecord::Base
  has_many :document_languages
  has_many :documents, through: :document_languages
end
