class Repository < ActiveRecord::Base
  after_commit :create_search_index!, on: :create
  after_commit :delete_index,         on: :destroy

  belongs_to :organization

  has_many :document_exports, dependent: :destroy,    autosave: true
  has_many :document_imports, dependent: :destroy,    autosave: true
  has_many :documents,        dependent: :destroy,    autosave: true
  has_many :value_mappings,   dependent: :delete_all, autosave: true

  def self.where_name(name)
    where('name ilike ?', "%#{name}%")
  end

  def search_index
    @search_index ||= Search::Indexes::DocumentsIndex.new(repository: self)
  end

  def create_search_index!
    search_index.create_index!
    search_index
  end

  def document_count
    documents.count
  end

  def delete_index
    search_index.delete_index!
  end

  def index_all_documents(skip_indexed: true)
    set = skip_indexed ? documents.where(indexed_at: nil) : documents
    set.find_in_batches { |docs| search_index.bulk_index(docs) }
  end
end
