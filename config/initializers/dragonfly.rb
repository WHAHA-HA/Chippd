require 'baby_image_processor'

app = Dragonfly[:images]

app.configure_with(:imagemagick)
app.configure_with(:rails)
app.processor.register(BabyImageProcessor)

Fog.mock! if Rails.env.test?

dragonfly_config = YAML.load_file(Rails.root.join('config/dragonfly.yml'))[Rails.env].symbolize_keys!

app.datastore = Dragonfly::DataStorage::S3DataStore.new

app.datastore.configure do |c|
  c.bucket_name = dragonfly_config[:bucket_name]
  c.access_key_id = dragonfly_config[:aws_access_key_id]
  c.secret_access_key = dragonfly_config[:aws_secret_access_key]
  c.url_scheme = 'https'
  c.url_host = dragonfly_config[:url_host]
end

app.define_macro_on_include(Mongoid::Document, :image_accessor)

configatron.s3.base_url = 'https://s3.amazonaws.com'
configatron.s3.access_key_id = dragonfly_config[:aws_access_key_id]
configatron.s3.secret_access_key = dragonfly_config[:aws_secret_access_key]
configatron.s3.bucket_name = dragonfly_config[:bucket_name]
configatron.s3.upload_bucket_name = dragonfly_config[:upload_bucket_name]
configatron.s3.cors_base_url = "https://#{dragonfly_config[:upload_bucket_name]}.s3.amazonaws.com"
configatron.amazon.region = dragonfly_config[:region]
configatron.amazon.pipeline_id = dragonfly_config[:pipeline_id]
configatron.amazon.sqs_queue_url = dragonfly_config[:sqs_queue_url]

AWS.config(access_key_id:     configatron.s3.access_key_id,
           secret_access_key: configatron.s3.secret_access_key)
