class Document < ActiveRecord::Base
  belongs_to :document_status
  belongs_to :repository
  belongs_to :url

  has_many :document_grades,         autosave: true
  has_many :document_identities,     autosave: true
  has_many :document_languages,      autosave: true
  has_many :document_resource_types, autosave: true
  has_many :document_standards,      autosave: true
  has_many :document_subjects,       autosave: true

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

  def initialize_from_import(import)
    raise NotImplementedError
  end

  def publishers
    identities_of(:publisher)
  end
end
