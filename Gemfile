source "https://rubygems.org"

ruby '1.9.3'

gem "rails", "3.2.19"
gem 'foreman'
gem 'unicorn'
gem "rack-ssl-enforcer"
gem 'rack-attack'
gem 'newrelic_rpm'

# MongoDB
gem "mongoid", "3.1.3"
gem 'mongoid_orderable'
gem 'mongoid_slug'

# UI
gem "kaminari"
gem "redcarpet", "~> 2.1.0"
gem 'table_cloth'
gem 'ariane'
gem "cocoon"

gem "simple_form"
gem "judge"
gem "judge-simple_form", :require => "judge/simple_form"
gem "country_select"

# Attachments
gem "rack-cache", :require => "rack/cache"
gem "fog"
gem "dragonfly", "0.9.13"

# Config
gem "configatron"

# Authentication
gem "devise"

# Controllers
gem "responders"
gem "has_scope"

# Miscellaneous
gem "stamp"
gem "yajl-ruby", :require => "yajl"
gem "money"
gem "gibberish"
gem "stripe"
gem 'vcard'
gem 'active_shipping'
gem "urbanairship"
gem "robocop"
gem 'bugsnag'
gem 'exception_notification'
gem 'memcachier'
gem 'dalli'
gem 'rack-rewrite', :require => 'rack/rewrite'
gem 'meta-tags', :require => 'meta_tags'
gem 'rubyzip'
gem 'hashie'
gem 'kiqstand'
gem 'sinatra'
gem 'slim'
gem 'sidekiq'
gem 'sidekiq-failures'
gem 'thin'
gem 'sitemap_generator'
gem 'axlsx_rails'
gem 'aws-sdk'
gem 'rails_12factor', group: :production
gem 'memoizable'
gem 'memoist', '~> 0.9.2'
gem 'strong_parameters'
gem 'pusher'
gem 'rack-cors', :require => 'rack/cors'
gem 'clockwork'
gem 'keen'

group :development do
  gem 'pry-rails'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'unicorn-rails'
  gem 'letter_opener'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem "sass-rails", "~> 3.2.4"
  gem "coffee-rails", "~> 3.2.2"
  gem "uglifier", "~> 1.2.3"
  gem "compass-rails", "~> 1.0.0"
  gem 'bootstrap-sass'
  gem 'jquery-ui-rails'
  gem 'turbo-sprockets-rails3'
  gem 'asset_sync'
end

gem "jquery-rails"

group :development, :test do
  gem 'dotenv-rails'
  gem 'rake'
  gem 'rspec-rails', '2.13.1'
  gem 'cucumber', '1.2.5'
  gem 'cucumber-rails', :require => false
  gem 'terminal-notifier-guard'
  gem 'guard', '>= 1.7.0'
  gem "guard-spork"
  gem "guard-bundler"
  gem "guard-rspec"
  gem "guard-cucumber"
  gem "fuubar"
  gem "fuubar-cucumber"
  gem 'ffaker'
  gem 'interactive_editor'
end

group :test do
  gem "codeclimate-test-reporter", require: nil
  gem 'rack-test'
  gem 'capybara'
  gem 'pickle'
  gem 'nokogiri'
  gem 'database_cleaner', '1.0.1'
  gem 'email_spec'
  gem 'factory_girl_rails'
  gem 'mongoid-rspec', '1.8.1'
  gem 'launchy'
  gem 'delorean'
  gem 'vcr'
  gem 'simplecov'
end
