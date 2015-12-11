class DocumentStatus < ActiveRecord::Base
  has_many :documents
  
  include HasValueField
  default_value_method :unpublished, :published, :hidden
end
