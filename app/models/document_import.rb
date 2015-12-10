require 'csv'

class DocumentImport < ActiveRecord::Base
  HEADER = %w[
    url title description grades publishers
    languages resource_types standards subjects
  ]

  mount_uploader :file, DocumentImportUploader

  belongs_to :repository

  has_many :document_import_rows, dependent: :destroy
  alias_attribute :rows, :document_import_rows

  validates :file, presence: true
  validates :repository, presence: true
  validate :check_csv

  def check_csv
    return unless file.try(:url)

    File.open(file.path) do |f|
      begin
        file_header = CSV.parse(f.readline).first.to_a
        unless check_header(file_header)
          errors.add(:file, :headers, headers: HEADER)
        end
      rescue ArgumentError
        errors.add(:file, :not_csv)
      rescue CSV::MalformedCSVError
        errors.add(:file, :malformed_csv)
      end
    end
  end

  def check_header(header)
    (header.map { |h| h.strip.downcase }.sort) == (HEADER.sort)
  end

  #
  # Processes the CSV and extracts valid and invalid documents before the import
  # job is confirmed by the user.
  #
  # Each row in the CSV becomes a row in the document_import_rows table.
  # 
  def prepare_import
    CSV.foreach(file.path, headers: true) do |csv_row|
      row = rows.build
      row.parse_csv_content(csv_row)
      row.save
    end

    touch(:prepared_at)
  end

  #
  # Creates mappings between row fields and entities in the database.
  # Those mappings will be used when the row is converted to a Document.
  #
  def create_mappings
    rows.find_each do |row|
      row.map_content
      row.save
    end

    touch(:mapped_at)
  end

  #
  # Imports rows extracted from a CSV. Each valid row in the document_import_rows
  # table is converted into a full-blown Document.
  # 
  def import
    rows.find_each do |row|
      doc = row.find_document || Document.new
      doc.initialize_from_import(row)
      if !doc.save
        row.import_errors = doc.errors
        row.save
      end
    end

    touch(:imported_at)
  end
end
