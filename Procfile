web: bundle exec unicorn -p $PORT -c ./config/unicorn.rb
worker: bundle exec sidekiq -q mailer -q pages -q api -q qr_codes
clock: bundle exec clockwork lib/clock.rb
