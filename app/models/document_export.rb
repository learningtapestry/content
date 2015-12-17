require 'csv'

class DocumentExport < ActiveRecord::Base
  EXPORT_TYPES = %w[csv]

  belongs_to :repository

  validates :repository, presence: true
  validates :export_type, presence: true, inclusion: EXPORT_TYPES

  def export
    documents = repository.documents

    if filtered_ids.present? && filtered_ids.any?
      documents.where!(id: filtered_ids)
    end

    open_csv do |csv|
      documents.order(id: :desc).find_each do |doc|
        csv << [
          doc.url.url,
          doc.title,
          doc.description,
          doc.grades.pluck(:name).join(','),
          doc.publishers.pluck(:name).join(','),
          doc.languages.pluck(:name).join(','),
          doc.resource_types.pluck(:name).join(',') ,
          doc.standards.pluck(:name).join(',') ,
          doc.subjects.pluck(:name).join(',')
        ]
      end
    end

    self.exported_at = Time.now
    save
  end

  def exported?
    exported_at.present?
  end

  protected

  def open_csv(&blk)
    current_time = "#{Time.now.utc.to_s.gsub(/ /, '_').gsub(/\:/, '-')}"
    path         = Rails.public_path.join('exports', 'csv')
    filename     = "Export_#{repository.id}__#{current_time}.csv"
    file         = path.join(filename).to_s
    headers      = DocumentImport::HEADER

    self.file = file
    FileUtils.mkdir_p(path)
    CSV.open(file, 'wb', write_headers: true, headers: headers, &blk)
  end
end
