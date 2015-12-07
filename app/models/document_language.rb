class DocumentLanguage < ActiveRecord::Base
  belongs_to :document, touch: true
  belongs_to :language
end
