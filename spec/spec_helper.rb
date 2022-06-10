require 'simplecov'
SimpleCov.start 'rails' do
  add_filter "/spec/"
  add_filter "/.bundle/"
end
require 'rubygems'
require 'spork'
#uncomment the following line to use spork with the debugger
#require 'spork/ext/ruby-debug'

Spork.prefork do
  require "codeclimate-test-reporter"
  CodeClimate::TestReporter.start

  # WebMock.disable_net_connect!(:allow => "codeclimate.com")

  # This file is copied to spec/ when you run 'rails generate rspec:install'
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'rspec/autorun'

  require 'sidekiq/testing'

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  RSpec.configure do |config|
    # ## Mock Framework
    #
    # If you prefer to use mocha, flexdouble or RR, uncomment the appropriate line:
    #
    # config.double_with :mocha
    # config.double_with :flexdouble
    # config.double_with :rr

    config.color_enabled = true

    # If true, the base class of anonymous controllers will be inferred
    # automatically. This will be the default behavior in future versions of
    # rspec-rails.
    config.treat_symbols_as_metadata_keys_with_true_values = true
    config.infer_base_class_for_anonymous_controllers = false
    config.include RSpec::Rails::RailsExampleGroup, example_group: { file_path: %r{spec/presenters} }
    config.include ActionView::TestCase::Behavior, example_group: { file_path: %r{spec/presenters} }
    config.include Rack::Test::Methods, example_group: { file_path: %r{spec/acceptance} }

    config.include Delorean

    config.before(:suite) do
      DatabaseCleaner.strategy = :truncation
      DatabaseCleaner.orm = "mongoid"
    end

    config.before(:each) do
      Pusher.stub(:[]).and_return(double('client', trigger: true))
      ApiKeyGenerator.stub(:generate).and_return {
        @counter ||= 1
        token = "s3cr3tt0k3n-#{@counter}"
        @counter += 1
        token
      }
      DatabaseCleaner.clean
    end
  end
end

Spork.each_run do
  FactoryGirl.reload
end

