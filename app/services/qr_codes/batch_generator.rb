class BatchGenerator
  attr_reader :batch
  attr_accessor :codes

  def self.call(batch_id)
    new(batch_id).call
  end

  def initialize(batch_id)
    @batch = Batch.find(batch_id)
    @codes = []
  end

  def call
    generate_codes
    persist_generated_codes
    write_manifest_package
  end

  protected

  def write_manifest_package
    BatchManifestWriter.write(batch.to_param)
  end

  def persist_generated_codes
    batch.codes.push(build_code_objects)
    batch.save
  end

  def build_code_objects
    codes.collect { |c| build_code_object(c) }
  end

  def build_code_object(code)
    Code.new(:value => code)
  end

  def generate_codes
    @codes = CodeValueGenerator.call(code_count_needed_to_complete_batch)
  end

  def code_count_needed_to_complete_batch
    batch.code_count - batch.codes.count
  end
end
