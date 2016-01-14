class RepositoryIndexAllDocumentsWorker
  include Sidekiq::Worker

  def perform(repository_id)
    repository = Repository.find(repository_id)
    repository.index_all_documents
  end
end
