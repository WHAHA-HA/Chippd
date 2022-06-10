require 'zip/zip'
require 'csv'

class BatchManifestWriter
  attr_reader :batch

  def self.write(batch_id)
    new(batch_id).write
  end

  def initialize(batch_id)
    @batch = Batch.find(batch_id)
  end

  def write
    create_zipfile
    save_zipfile_to_batch
    cleanup
  end

  protected

  def tmp
    Rails.root.join('tmp')
  end

  def save_zipfile_to_batch
    batch.file = File.new(zipfile_name)
    batch.save
  end

  def create_zipfile
    create_batch_folder
    Zip::ZipFile.open(zipfile_name, Zip::ZipFile::CREATE) do |zipfile|
      zipfile.add(batch_folder, tmp.join(batch_folder))
      Dir["#{tmp.join(batch_folder)}/**/**"].each do |file|
        zipfile.add(file.sub((tmp.to_s + '/'), ''), file)
      end
      create_and_add_manifest_to_zipfile(zipfile)
      create_and_add_csv_to_zipfile(zipfile)
    end
  end

  def create_batch_folder
    %w(source 6x6 12x12 source/eps source/pdf).each { |d| FileUtils.mkdir_p tmp.join("#{batch_folder}/#{d}") }
  end

  def zipfile_name
    tmp.join("#{batch_folder}.zip")
  end

  def batch_folder
    batch.number.to_s
  end

  def manifest
    if @manifest
      @manifest
    else
      @manifest = Tempfile.new('manifest')
      @manifest.write(batch.codes.collect(&:value).join("\n"))
      @manifest.close
      @manifest
    end
  end

  def create_and_add_manifest_to_zipfile(zipfile)
    zipfile.add("#{batch_folder}/code-manifest.txt", manifest.path)
  end

  def create_and_add_csv_to_zipfile(zipfile)
    CSV.open(csv_path, "wb") do |csv|
      csv << %w(value redeem)
      batch.codes.each do |code|
        csv << code.to_csv_row
      end
    end
    zipfile.add("#{batch_folder}/#{csv_name}", csv_path)
  end

  def csv_name
    'manifest.csv'
  end

  def csv_path
    tmp.join("#{batch_folder}/#{csv_name}")
  end

  def cleanup
    cleanup_batch_folder
    cleanup_zipfile
  end

  def cleanup_zipfile
    FileUtils.rm(zipfile_name) if File.exists?(File.join(zipfile_name))
  end

  def cleanup_batch_folder
    FileUtils.rm_rf(tmp.join(batch_folder)) if File.exists?(tmp.join(batch_folder))
  end
end