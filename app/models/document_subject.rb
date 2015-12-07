class DocumentSubject < ActiveRecord::Base
  belongs_to :document, touch: true
  belongs_to :subject
end
