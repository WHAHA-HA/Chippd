require 'fileutils'

class DatabaseConfig
  attr_reader :uri, :host, :port

  def initialize
    @uri = Moped::MongoUri.new(ENV['MONGOHQ_URL'])
    primary_node = @uri.hosts.first.split(':')
    @host = primary_node.first
    @port = primary_node.last
  end

  def username
    uri.username
  end

  def password
    uri.password
  end

  def remote_database
    uri.database
  end

  def local_database
    Mongoid.default_session.options[:database]
  end
end

def database_config
  @database ||= DatabaseConfig.new
end

def make_production_snapshot
  [
    "rm -rf dump/*",
    "mongodump -u #{database_config.username} -p #{database_config.password} --host #{database_config.host} --port #{database_config.port} -d #{database_config.remote_database}",
    "rm dump/#{database_config.remote_database}/system.*.bson"
  ].each { |c| sh(c) }
end

def parsed_user_data
  ENV['ADMIN_USERS'].split('/').collect { |u| u.split(':') }
end
namespace :cms do
  task :create_admin => :environment do
    users = parsed_user_data

    users.each do |email, password, level|
      admin = Admin.find_or_create_by(:email => email)
      admin.password = password
      admin.password_confirmation = password
      admin.level = level.to_sym
      admin.save
    end
  end
end

namespace :db do
  namespace :sync do
    task local: :environment do
      make_production_snapshot
      sh("mongorestore --drop --port #{ENV['BOXEN_MONGODB_PORT'] || 27017 } -d #{database_config.local_database} dump/#{database_config.remote_database}")
    end
  end
end

def copy_slug(e)
  slugs = []
  if e[:slug_history] != nil
    e[:slug_history].each do |h|
      slugs << h unless (h == nil || h == "")
    end
  end
  slugs << e[:slug]
  e[:_slugs] = slugs
  e.save
  p " - #{e[:_slugs]}"
end

task :migrate_slugs => :environment do
  Content.all.each do |c|
    copy_slug(c)
  end
end

task :landing_pages => :environment do
  LandingPage.each do |landing_page|
    landing_page.images.each do |image|
      image.original_url = image.image.remote_url
      image.save
    end
    landing_page.steps.each do |step|
      step.original_url = step.image.remote_url
      step.save
    end
  end
end

task :copy_products_across_collections => :environment do
  love = ProductCollection.first
  other_collections = ProductCollection.where(:id.ne => love.id)
  product_params_to_remove = %w(_id product_collection_id created_at updated_at details images)
  product_image_params_to_remove = %w(_id image_uid large_uid medium_uid small_uid square_uid)

  other_collections.each do |collection|
    puts "Collection: #{collection.name}"
    products = love.products.to_a
    products.each do |product|
      puts "Product: #{product.name} (#{products.index(product) + 1}/#{products.length})"
      new_attributes = product.attributes.dup
      product_params_to_remove.each { |p| new_attributes.delete(p) }
      new_product = collection.products.create(new_attributes)
      images = product.images.to_a
      images.each do |image|
        puts "Image: #{image.caption} (#{images.index(image) + 1}/#{images.length})"
        new_attributes = image.attributes.dup
        product_image_params_to_remove.each { |p| new_attributes.delete(p) }
        new_image = new_product.images.build(new_attributes)
        puts "(#{image.large.remote_url})"
        new_image.image_url = image.large.remote_url
        new_image.save
      end
    end
    puts
  end
end

task :assign_default_page_template => :environment do
  default_id = '52959157487ea0f539000001'
  page_template = PageTemplate.find(default_id)
  Page.all.each do |page|
    if page.page_template.blank?
      page.page_template = page_template
      page.save
    end
  end
end

task :hijack_user => :environment do
  if Rails.env.development?
    customer = Customer.where(:email => ENV['EMAIL']).first
    customer.password = '123abc123'
    customer.password_confirmation = '123abc123'
    customer.save
  end
end

task :assign_default_product_collection => :environment do
  love = ProductCollection.find('love')
  flock = ProductCollection.find('flock')
  story = ProductCollection.find('story')
  ids = {
    "4fb135d117320a0001000005" => love,
    "4fb1362417320a0001000009" => story,
    "4fb1360117320a0001000007" => flock
  }
  no_matches = []
  Page.all.each do |page|
    if ids.keys.include?(page.chippd_product_type_id.to_s)
      page.product_collection = ids[page.chippd_product_type_id.to_s]
      page.save
    else
      no_matches << page.to_param
    end
  end
  puts "Pages without a product collection match:"
  puts no_matches.join("\n")
end

task :fix_pluralized_widgets => :environment do
  widgets = [:wedding_events, :baby_arrives, :baby_grows, :babys_favorites]
  PageTemplate.all.each do |template|
    template.widgets.each do |widget|
      if widgets.include?(widget.type)
        widget.type = "#{widget.type}_widget"
        widget.save
      end
    end
  end
end

task :migrate_customer_name_to_first_and_last => :environment do
  Customer.all.each do |customer|
    customer.v1_api!
    name = customer[:name]
    customer.name = name
    customer.save
  end
end

task :track_page_storage_used => :environment do
  Page.all.each(&:track_storage_used!)
end

task :migrate_static_babys_favorites => :environment do
  Page.all.each do |page|
    page.sections.each do |section|
      if section.is_a?(BabysFavoritesWidget) && section.favorites.blank?
        p "updating babys_favorites section #{section.to_param}"
        if section[:toy].present?
          section.favorites << Favorite.new(category: 'Toy', title: section[:toy])
        end
        if section[:song].present?
          section.favorites << Favorite.new(category: 'Song', title: section[:song])
        end
        if section[:book].present?
          section.favorites << Favorite.new(category: 'Book', title: section[:book])
        end
        if section[:person].present?
          section.favorites << Favorite.new(category: 'Person', title: section[:person])
        end
        if section[:food].present?
          section.favorites << Favorite.new(category: 'Food', title: section[:food])
        end
        section.save
      end
    end
  end
end
