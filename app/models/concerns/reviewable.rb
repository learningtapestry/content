require 'active_support/concern'

module Reviewable
  extend ActiveSupport::Concern

  included do
    belongs_to :review_status

    after_initialize :set_review_status_default

    def set_review_status_default
      self.review_status ||= ReviewStatus.not_reviewed
    end
  end

end
