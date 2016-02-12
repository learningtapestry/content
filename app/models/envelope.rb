class Envelope < ActiveRecord::Base
  DOC_TYPE    = 'resource_data'
  DOC_VERSION = '0.51.1'
  NODE_ID     = 'TBA'

  enum payload_placement: { attached: 1, inline: 2, linked: 3 }
  enum submitter_type: { agent: 1, anonymous: 2, user: 3 }

  validates :active, :payload_placement, :resource_data_type, :resource_locator, :submission_tos, :submitter, :submitter_type, presence: true
  validates :payload_locator, presence: true, if: :linked?
  validates :resource_data, presence: true, if: :inline?
  validates :signature, :signature_key_location, :signing_method, presence: true, if: :signature_present?
  validates :weight, numericality: { greater_than_or_equal_to: -100, less_than_or_equal_to: 100 }, allow_nil: true

  before_save :generate_doc_id

  def self.create_or_update(params)
    doc_id = params[:doc_ID]

    envelope = find_or_initialize_by(doc_id: doc_id) do |e|
      e.active                   = params[:active]
      e.doc_type                 = DOC_TYPE
      e.doc_version              = DOC_VERSION
      e.keys                     = params[:keys]
      e.payload_placement        = params[:payload_placement]
      e.payload_schema           = params[:payload_schema]
      e.payload_schema_format    = params[:payload_schema_format]
      e.payload_schema_locator   = params[:payload_schema_locator]
      e.publishing_node        ||= NODE_ID
      e.resource_data_type       = params[:resource_data_type]
      e.resource_locator         = params[:resource_locator]
      e.resource_ttl             = params[:resorce_TTL]
      e.weight                   = params[:weight]

      e.submitter_timestamp = params[:submitter_timestamp]
      e.submitter_ttl = params[:submitter_TTL]

      if e.inline?
        e.resource_data = params[:resource_data]
      end

      if e.linked?
        e.payload_locator = params[:payload_locator]
      end

      if (identity = params[:identity]).is_a?(Hash)
        e.curator        = identity[:curator]
        e.owner          = identity[:owner]
        e.signer         = identity[:signer]
        e.submitter      = identity[:submitter]
        e.submitter_type = identity[:submitter_type]
      end

      if (signature = params[:signature]).is_a?(Hash)
        e.signature              = signature[:signature]
        e.signature_key_location = signature[:key_location]
        e.signing_method         = signature[:signing_method]
      end

      if (tos = params[:TOS]).is_a?(Hash)
        e.submission_attribution = tos[:submission_attribution]
        e.submission_tos         = tos[:submission_TOS]
      end
    end

    envelope.save
    envelope
  end

  private

  def generate_doc_id
    begin
      self.doc_id = SecureRandom.hex
    end while Envelope.exists?(doc_id: doc_id)
  end

  def signature_present?
    signature.present? ||
      (signature_key_location || []).any? ||
      signing_method.present?
  end
end
