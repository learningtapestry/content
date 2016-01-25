require 'securerandom'
require 'test_helper'

module Search
  module Indexes
    class DocumentsIndexTest < ActiveSupport::TestCase
      setup do
        delete_indices
        @khan_repo = repositories(:khan)
        @lt = organizations(:lt)
      end

      test '#index_name is composed with repo ID and environment' do
        index = DocumentsIndex.new(repository: @khan_repo)

        assert_match(/#{@khan_repo.id}/, index.index_name)
        assert_match(/test/,             index.index_name)
      end

      test '#create_index! creates a new index' do
        index = DocumentsIndex.new(repository: @khan_repo)

        refute index.index_exists?
        index.create_index!

        assert index.index_exists?
      end

      test '#delete_index! deletes an index' do
        index = DocumentsIndex.new(repository: @khan_repo)

        index.create_index!
        assert index.index_exists?

        index.delete_index!
        refute index.index_exists?
      end

      test '#save indexes a document' do
        index = DocumentsIndex.new(repository: @khan_repo)
        doc = documents(:khan_intro_algebra)

        assert index.save(doc)
        assert doc.indexed?
      end

      test '#delete deletes a document from the index' do
        index = DocumentsIndex.new(repository: @khan_repo)
        doc = documents(:khan_intro_algebra)
        index.save(doc)

        assert index.delete(doc)
        refute doc.indexed?
      end

      test '#bulk_index indexes in bulk' do
        repo = repositories(:has_3_docs)
        repo.documents.update_all(indexed_at: nil)

        index = DocumentsIndex.new(repository: repo)
        index.bulk_index(repo.documents)
        repo.documents.reload

        assert repo.documents.all? { |doc| doc.indexed? }
      end
    end
  end
end
