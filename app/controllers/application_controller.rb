require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  protect_from_forgery
  layout :layout_by_resource
  helper :all
  helper_method :markdown, :home?, :admin_home?, :my_chippd?, :default_meta_tags, :ios_legacy?

  protected

  def set_meta_tags(options = {})
    default_meta_tags
    @default_meta_tags.merge!(options)
  end

  def default_meta_tags
    @default_meta_tags ||= {
      :site => "By Chipp'd",
      :title => 'Smart Gifts and Greeting Cards',
      :description => "We make physical products that unlock exclusive digital content. Use Chipp'd to share things with someone you love, a select group, or the world.",
      :keywords => 'Fashion technology, wearable technology, fashion tech, wearable tech, friendship bracelets, friendship bracelet, smart bracelets, smart bracelet, fashion accessories, bracelet, bracelets, qr codes, gift, private, personal, qr, new york city, made in nyc, nyc',
      :reverse => true,
      :open_graph => {
        :image => "https://#{HOST}/avatar.png"
      }
    }
  end

  def after_sign_in_path_for(resource)
    stored_location_for(resource) ||
    if resource.is_a?(Customer)
      if redeemable?
        my_chippd_redemptions_url
      else
        my_chippd_root_url
      end
    else
      admin_root_url
    end
  end

  def layout_by_resource
    if devise_controller? && resource_name == :admin
      "admin"
    elsif devise_controller? && resource_name == :customer
      "simple"
    else
      "application"
    end
  end

  def setup_pagination_parameters
    @page = params[:page] || 1
    @per = params[:per] || 50
  end

  def markdown(text)
    @h ||= Redcarpet::Render::HTML.new(:hard_wrap => true)
    @m ||= Redcarpet::Markdown.new(@h, :autolink => true, :space_after_headers => true)
    @m.render(text).html_safe
  end

  def home?
    controller_name == 'pages' && action_name == 'home'
  end

  def admin_home?
    devise_controller? || (controller_path == "admin/base" && action_name == "home")
  end

  def current_subnav_path
    @current_subnav_path ||= request.path_info
  end

  def setup_subnav
    @subnav = SubnavPresenter.new(current_subnav_path)
  end

  def my_chippd?
    @my_chippd
  end

  def redeemable?
    session[:redeemable]
  end

  def ios_legacy?
    false
  end
end