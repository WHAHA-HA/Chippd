class PageSectionPresenter < BasePresenter
  presents :page_section
  delegate :_type, :to_param, :to_key, :position, :uses_storage?, :impression_stats, :to => :page_section

  class << self
    delegate :model_name, :to => PageSection
  end

  def type
    PageSectionTypePresenter.new(page_section.symbolized_type, PagePresenter.new(page_section.page, @template), @template)
  end

  def available?
    page_section.active?
  end

  def not_available?
    page_section.error?
  end

  def not_available_message
    content_tag(:p, "There was an error processing your media file.  Please contact us at #{mail_to('help@chippd.com', 'help@chippd.com')} if you'd like some help or delete this page section and try again with a different media file.".html_safe, :class => "")
  end

  def processing?
    page_section.pending?
  end

  def processing_message
    content_tag(:p, "Your content is currently being processed. It will automatically be displayed upon completion.", :class => "processing", :style => "background-image: url(#{asset_path("ajax-loader.gif")})")
  end

  def to_longpage_nav_item
    @template.content_tag(:a, :href => "##{page_section.to_param}", :class => "scroll", :style => "background-image: url(#{asset_path("my_chippd/icon-#{type}.png")});") do
      @template.concat(self.sortable_content)
    end
  end

  def to_sortable_list_item
    @template.content_tag(:li, :id => ['page_section', to_param].join('_'), :class => page_section._type, 'aria-hidden' => 'true', 'data-icon' => '|', :style => "background-image: url(#{asset_path("my_chippd/icon-#{type}.png")});") do
      @template.concat(self.sortable_content)
    end
  end

  def storage_used
    number_to_human_size(page_section.storage_used)
  end

  def created_at
    page_section.created_at.stamp(configatron.date_formats.long)
  end

  protected

  def sortable_content
    type.name
  end
end
