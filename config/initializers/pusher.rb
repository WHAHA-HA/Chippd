configatron.pusher.app_id = ENV['PUSHER_APP_ID']
configatron.pusher.key    = ENV['PUSHER_KEY']
configatron.pusher.secret = ENV['PUSHER_SECRET']

Pusher.app_id = configatron.pusher.app_id
Pusher.key    = configatron.pusher.key
Pusher.secret = configatron.pusher.secret
