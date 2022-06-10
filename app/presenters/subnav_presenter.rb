require 'ostruct'

class SubnavPresenter
  attr_reader :heading, :nav_items, :current_path

  def initialize(current_path)
    @current_path = current_path
    @heading = find_heading_by_current_path
    @nav_items = find_nav_items_by_current_path
  end

  def title
    self.heading.title
  end

  def pages
    @pages ||= [
      OpenStruct.new(:title => "About Us", :path => r.about_us_path),
      OpenStruct.new(:title => "Press", :path => r.press_releases_path),
      OpenStruct.new(:title => "FAQ", :path => r.faq_path),
      OpenStruct.new(:title => "Contact Us", :path => r.contact_us_path),
      OpenStruct.new(:title => "Terms of Service", :path => r.terms_of_service_path),
      OpenStruct.new(:title => "Privacy Policy", :path => r.privacy_policy_path)
    ]
  end

  private

  def find_heading_by_current_path
    self.pages.detect { |i| i.path == self.current_path }
  end

  def find_nav_items_by_current_path
    self.pages.reject { |i| i.path == self.current_path }
  end

  def routes
    Rails.application.routes.url_helpers
  end
  alias_method :r, :routes
end