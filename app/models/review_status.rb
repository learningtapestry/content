class ReviewStatus < ActiveRecord::Base
  include HasValueField
  default_value_method :system, :not_reviewed, :reviewed
end
