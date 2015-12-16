class ValueMapping < ActiveRecord::Base
  belongs_to :repository
  belongs_to :mappable, polymorphic: true
end
