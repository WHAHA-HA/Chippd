class PagePresenter < BasePresenter
  presents :page
  delegate :name, :line_items, :to_key, :heading, :customer_id, :subheading, :eligible_for_notification?, :members_who_have_not_responded_to, :b2b_enabled?, :push_notification_sent?, :estimated_monthly_cost?, :to => :page

  class << self
    delegate :model_name, :to => Page
  end

  def page_variation
    page.page_template.variation.to_s
  end

  def product_collection
    @product_collection ||= ProductCollectionPresenter.new(page.product_collection, @template)
  end

  def chippd_product_type
    @chippd_product_type ||= ChippdProductTypePresenter.new(page.chippd_product_type, @template)
  end

  def quantity_limit_for_section(section)
    widgets.find { |a| a['key'] == section }['limit']
  end

  def widgets
    @widgets ||= page.page_template.widgets
  end

  def image
    chippd_product_type.image(name, 200)
  end

  def line_items(add_bracelet = true)
    content_tag(:ul, :id => 'page-line-items-list') do
      page.line_items.reject { |li| li.product.blank? }.collect { |line_item| concat(PageLineItemPresenter.new(line_item, @template).to_li) }
      if add_bracelet
        concat(content_tag(:li, link_to('Add Product', store_products_by_product_collection_and_page_template_path(page.product_collection_id, page.page_template_id, page_id: page.to_param), :class => 'add-bracelet')))
      end
    end
  end

  def sections
    page.sections.collect { |section| "#{section._type}Presenter".constantize.new(section, @template) }
  end

  def has_sections?
    page.sections.present?
  end

  def needs_long_page_navigation?
    has_sections? && page.sections.length > configatron.pages.long_page_navigation_threshold
  end

  def no_sections_yet_message
    content_tag(:div, markdown(I18n.t("page.no_sections_yet")), :class => 'no-sections-yet')
  end

  def memberships
    page.memberships.collect { |membership| MembershipPresenter.new(membership, @template) }
  end

  def to_param
    page.to_param
  end

  def header
    if display_page_heading?
      @template.content_tag(:header) do
        @template.concat(@template.content_tag(:h1, page.heading))
        @template.concat(@template.content_tag(:p, page.subheading)) if subheading?
      end
    end
  end

  def link_to_reorder
    when_sections_can_be_reordered do
      content_tag(:div, link_to('reorder content', '#', 'aria-hidden' => 'true', 'data-icon' => 'l', 'data-behavior' => 'reorder-page-sections'), :class => 'reorder')
    end
  end

  def when_sections_can_be_reordered
    yield if page.sections.length > 1
  end

  def eligible_to_notify_next_at
    time_ago_in_words(page.eligible_to_notify_next_at.in_time_zone)
  end

  def notification_last_sent_at
    page.notification_last_sent_at.present? ? page.notification_last_sent_at.stamp(configatron.date_formats.long) : 'n/a'
  end

  def storage_used
    number_to_human_size(page.storage_used)
  end
  
  def storage_used_in_last_days(last_days)
    days = case last_days
      when :total then return storage_used
      when :day then 2
      when :week then 8
      when :month then 31
    end
    number_to_human_size(page.storage_used.last_days(days).sum)
  end

  def member_count
    page.memberships.count
  end

  def section_count
    page.sections.count
  end

  def estimated_monthly_cost
    number_to_currency(page.estimated_monthly_cost.to_s, :unit => page.monthly_cost_currency)
  end

  protected

  def subheading?
    page.subheading.present?
  end

  def display_page_heading?
    page.heading.present?
  end
end
