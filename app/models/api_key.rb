require 'securerandom'

class ApiKey < ActiveRecord::Base
  belongs_to :organization
  rolify

  def generate_key
    self.key = SecureRandom.uuid
  end

  def expire!
    update_attributes(expired: true)
  end
end
