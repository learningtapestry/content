require 'active_support/concern'

module Indexable
  extend ActiveSupport::Concern

  included do
    class_attribute :index_class
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

    def self.acts_as_indexed(index_class=nil)
      self.index_class = index_class || "Search::Indexes::#{self.name}Index".constantize
    end

    def search_index
      @search_index ||= self.class.index_class.new(repository: self.try(:repository))
    end

    def skip_indexing?
      !!skip_indexing || !search_index.index_exists?
    end

    def indexed?
      indexed_at.present?
    end
  end
end
