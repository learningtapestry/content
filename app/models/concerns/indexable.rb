require 'active_support/concern'

# Defines behavior for indexable models on ElasticSearch
# Usage:
#
#    class MyModel < ActiveRecord:Base
#       include Indexable
#       acts_as_indexed  # will point to Search::Indices::MyModelIndex
#
module Indexable
  extend ActiveSupport::Concern

  included do
    class_attribute :index_class, :search_class
    attr_accessor :skip_indexing

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

    # Mark the model as indexed.
    # The index will point to `Search::Indices::<ModelName>Index`.
    #
    # Optionally you can pass an index_class. E.g:
    #
    #  class MyModel < ActiveRecord:Base
    #    include Indexable
    #    acts_as_indexed  Search::Indices::SomeOtherIndex
    #
    def self.acts_as_indexed(index_class=nil)
      self.index_class = index_class || "Search::Indices::#{self.name.pluralize}Index".constantize
      self.search_class ||= "Search::#{self.name}Search".constantize
    end

    # Points to proper index. If the instance has a repository, then starts
    # the index for that specific repo
    def search_index
      @search_index ||= self.class.index_class.new(repository: self.try(:repository))
    end

    # search
    def self.search(term, options={})
      params = options.merge q: term
      self.search_class.new.search params
    end

    def skip_indexing?
      !!skip_indexing || !search_index.index_exists?
    end

    def indexed?
      indexed_at.present?
    end
  end
end
