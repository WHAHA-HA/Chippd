UrbanairshipConfig = YAML.load(ERB.new(File.new(Rails.root.join('config/urbanairship.yml')).read).result)[Rails.env].symbolize_keys!

def push_logger
  if @push_logger
    @push_logger
  else
    log_file = File.open(Rails.root.join("log", "push_notifications.log"), 'a')
    log_file.sync = true
    @push_logger = Logger.new(log_file)
  end
end

Urbanairship.application_key = UrbanairshipConfig[:application_key]
Urbanairship.application_secret = UrbanairshipConfig[:application_secret]
Urbanairship.master_secret = UrbanairshipConfig[:master_secret]
Urbanairship.logger = push_logger
Urbanairship.request_timeout = 5 # default