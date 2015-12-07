class DocumentStandard < ActiveRecord::Base
  belongs_to :document, touch: true
  belongs_to :standard
end
