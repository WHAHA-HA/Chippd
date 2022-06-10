class PagesController < ApplicationController
  before_filter :setup_subnav, :only => [:about_us, :faq, :retailers, :contact_us, :terms_of_service, :privacy_policy]

  def home
    @product_collections = ProductCollection.visible
    @products = ProductPresenter.from_collection(Product.visible, view_context)
  end

  def about_us
    @content = ContentPresenter.new(Content.fetch!('about-us'), view_context)
    set_meta_tags({
      :site => "That's Chipp'd.",
      :title => 'Making the Internet More Fun and Personal'
    })
  end

  def go
  end

  def how_it_works
    @product_collections = ProductCollection.visible
    set_meta_tags({
      :site => "With Chipp'd",
      :title => "Sharing Private Content is Fun and Easy"
    })
  end

  def press_kit
  end

  def faq
    @faqs = FaqPresenter.from_collection(Faq.visible, view_context)
    set_meta_tags({
      :site => "Chipp'd FAQs.",
      :title => "Answers to Common Questions"
    })
  end

  def retailers
    @content = ContentPresenter.new(Content.fetch!('retailers'), view_context)
  end

  def terms_of_service
    @content = ContentPresenter.new(Content.fetch!('terms-of-service'), view_context)
    set_meta_tags({
      :site => "Chipp'd Terms of Service.",
      :title => "Without Rules, There Would be Chaos"
    })
  end

  def privacy_policy
    @content = ContentPresenter.new(Content.fetch!('privacy-policy'), view_context)
    set_meta_tags({
      :site => "Chipp'd Privacy Policy.",
      :title => "Because Your Data Should Remain Yours"
    })
  end

  def redeem_tracking
    session[:redeemable] = true
    redirect_to new_customer_session_url, :notice => "Please sign in or create an account to redeem your gift."
  end
end
