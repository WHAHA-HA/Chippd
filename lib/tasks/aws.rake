# task :sync_s3_buckets => :environment do
#   require 'benchmark'
#   dragonfly_config = YAML.load_file(Rails.root.join('config/dragonfly.yml'))[Rails.env].symbolize_keys!

#   from_bucket_name = "chippd-production-backup"
#   to_bucket_name = "chippd-com-production"
#   access_key_id = dragonfly_config[:aws_access_key_id]
#   secret_access_key = dragonfly_config[:aws_secret_access_key]

#   AWS.config(access_key_id: access_key_id, secret_access_key: secret_access_key)

#   from_bucket = AWS::S3.new.buckets[from_bucket_name]
#   to_bucket = AWS::S3.new.buckets[to_bucket_name]

#   bm = Benchmark.measure do
#     puts "getting from_bucket keys..."
#     from_bucket_keys  = from_bucket.objects.map(&:key)
#     puts "from_bucket_keys.length: #{from_bucket_keys.length}"
#     puts "getting to_bucket keys..."
#     to_bucket_keys  = to_bucket.objects.map(&:key)
#     puts "to_bucket_keys.length: #{to_bucket_keys.length}"

#     keys_to_copy = from_bucket_keys - to_bucket_keys
#     puts "COPYING #{keys_to_copy.length} objects FROM #{from_bucket_name} to #{to_bucket_name}"

#     keys_to_copy.each do |key|
#       puts "COPYING #{key}"
#       obj = from_bucket.objects[key]
#       obj.copy_to(key, :bucket_name => to_bucket_name, :acl => :public_read)
#     end

#     # keys_to_delete = (to_bucket_keys+keys_to_copy) - from_bucket_keys
#     # puts "DELETING #{keys_to_delete.length} objects FROM #{to_bucket_name}"

#     # to_bucket.objects.delete(keys_to_delete)
#   end
#   puts "Took #{bm.real}s"
# end