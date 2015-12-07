class DocumentImportUploader < CarrierWave::Uploader::Base
  storage :file

  process :check_csv

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_white_list
    %w(csv)
  end

  def check_csv
    
  end
end
