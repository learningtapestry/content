class Document < ActiveRecord::Base
  attr_accessor :skip_indexing

  belongs_to :document_status
  belongs_to :repository
  belongs_to :url

  has_many :document_grades,         dependent: :delete_all, autosave: true
  has_many :document_identities,     dependent: :delete_all, autosave: true
  has_many :document_languages,      dependent: :delete_all, autosave: true
  has_many :document_resource_types, dependent: :delete_all, autosave: true
  has_many :document_standards,      dependent: :delete_all, autosave: true
  has_many :document_subjects,       dependent: :delete_all, autosave: true

  has_many :identities,     through: :document_identities
  has_many :grades,         through: :document_grades
  has_many :languages,      through: :document_languages
  has_many :resource_types, through: :document_resource_types
  has_many :standards,      through: :document_standards
  has_many :subjects,       through: :document_subjects

  validates :url,   presence: true
  validates :title, presence: true

  def self.find_by_url(url)
    where(url: Url.find_by(url: url)).first
  end

  #
  # Adds an identity of a certain type
  #
  def add_identity(identity, idt_type_val)
    document_identities.build(
      identity: identity,
      identity_type: IdentityType.find_by(value: idt_type_val)
    )
  end

  #
  # Finds identities by identity type.
  #
  def identities_of(idt_type_val)
    Identity
      .joins(:document_identities)
      .where('document_identities.document_id = ?', self.id)
      .where('document_identities.identity_type_id = ?',
        IdentityType.find_by(value: idt_type_val).id)
  end

  #
  # Returns publisher identities
  # 
  def publishers
    identities_of(:publisher)
  end

  #
  # Searching
  #
  after_commit :index_document, on: [:create, :update], unless: :skip_indexing?
  after_commit :delete_document, on: :destroy, unless: :skip_indexing?

  def index_document
    begin
      search_index.save(self)
    rescue Faraday::ConnectionFailed; end
  end

  def delete_document
    begin
      search_index.delete(self)
    rescue Faraday::ConnectionFailed; end
  end

  def search_index
    repository.search_index
  end

  def skip_indexing?
    !!skip_indexing || !search_index.index_exists?
  end

  def indexed?
    indexed_at.present?
  end

  def as_indexed_json
    DocumentIndexedSerializer.new(self).as_json
  end

  # This is just a handy method to get the correct timezone for doing
  # manual .touch operations in bulk.
  def _current_time_from_proper_timezone
    current_time_from_proper_timezone
  end

end
