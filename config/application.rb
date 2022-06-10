require File.expand_path('../boot', __FILE__)

# Since we're not using activerecord and
# activeresource, we'll only load what
# we need.
require "action_controller/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require(*Rails.groups(:assets => %w(development test)))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end

module Chippd
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.middleware.insert 0, 'Rack::Cache', {
      :verbose     => true,
      :metastore   => URI.encode("file:#{Rails.root}/tmp/dragonfly/cache/meta"),
      :entitystore => URI.encode("file:#{Rails.root}/tmp/dragonfly/cache/body")
    } unless Rails.env.production? || Rails.env.staging? ## this 'unless' is only needed in Rails 3.1 because
                                                         ## Rack::Cache is automatically inserted in production

    config.middleware.insert_after 'Rack::Cache', 'Dragonfly::Middleware', :images

    config.sass.load_paths << Compass::Frameworks['compass'].stylesheets_directory if config.respond_to?(:sass)

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Add additional load paths for your own custom dirs
    # config.load_paths += %W( #{config.root}/extras )
    require "chippd"
    config.autoload_paths += Dir["#{config.root}/lib/**/"]
    %w(models presenters services policies queries).each do |app_folder|
      config.autoload_paths += Dir["#{config.root}/app/#{app_folder}/**/"]
    end

    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Eastern Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password, :password_confirmation]

    # Use SQL instead of Active Record's schema dumper when creating the database.
    # This is necessary if your schema can't be completely dumped by the schema dumper,
    # like if you have constraints or database-specific column types
    # config.active_record.schema_format = :sql

    # Enforce whitelist mode for mass assignment.
    # This will create an empty whitelist of attributes available for mass-assignment for all models
    # in your app. As such, your models will need to explicitly whitelist or blacklist accessible
    # parameters by using an attr_accessible or attr_protected declaration.
    # config.active_record.whitelist_attributes = true

    config.middleware.use Rack::Attack

    # Configure generators values
    config.generators do |g|
      g.test_framework      :rspec, :fixture => true
      g.fixture_replacement :factory_girl, :dir => "spec/factories"
      g.stylesheets false
      g.javascripts false
      g.view_specs false
      g.helper_specs false
    end

    # Allow cross-domain requests on aws signatures endpoint
    config.middleware.use Rack::Cors do
      allow do
        origins '*'
        resource '/2/signatures', :headers => :any, :methods => [:post, :options]
      end
    end

    #asset pipeline
    config.assets.enabled = true

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'

    config.assets.initialize_on_precompile = false

    config.assets.paths << Rails.root.join('app', 'assets', 'fonts')

    config.assets.precompile += %w(
      base.js
      admin.js
      admin.css
      simple.css
      simple.js
      my_chippd.css
      my_chippd.js
      chippd_page.css
      chippd_page.js
      store/customer_information.js
      store/review.js
      store/products.js
      vimeo_api.js
      modernizr-min.js
      selectivizr-min.js
      widget_page.js
      wedding.css
      baby.css
      .svg
      .eot
      .woff
      .ttf
      keen.js
    )

    # send emails when exceptions happen
    config.middleware.use ExceptionNotification::Rack,
      :email => {
      :email_prefix => "[Exception - #{Rails.env}] ",
        :sender_address => %{"Exception Notifier" <admin@chippd.com>},
        :exception_recipients => %w{keith@chippd.com jwirman@gmail.com}
    }

  end
end
