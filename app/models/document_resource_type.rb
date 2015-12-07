class DocumentResourceType < ActiveRecord::Base
  belongs_to :document, touch: true
  belongs_to :resource_type
end
