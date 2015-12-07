class DocumentGrade < ActiveRecord::Base
  belongs_to :document, touch: true
  belongs_to :grade
end
