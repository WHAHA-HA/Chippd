class Store::BaseController < ApplicationController
  helper_method :current_order?, :current_order

  before_filter :fetch_current_order
  before_filter :add_top_level_breadcrumb

  protected

  def default_meta_tags
    super.merge!({
      :site => "By Chipp'd",
      :title => 'Smart Gifts and Greeting Cards'
    })
  end

  def add_top_level_breadcrumb
    ariane.add "Collections", store_root_path
  end

  def current_order?
    @current_order
  end

  def current_order
    @current_order
  end

  def fetch_current_order
    if session[:order_id]
      @current_order = OrderPresenter.new(Order.find(session[:order_id]), view_context)
    else
      @current_order = nil
    end
  rescue Mongoid::Errors::DocumentNotFound
    @current_order = nil
  end
end
