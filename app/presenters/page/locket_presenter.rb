class LocketPresenter < PageSectionPresenter
  delegate :title, :to => :page_section

  def body
    markdown(page_section.body)
  end

  def image_one
    image_tag(page_section.image_one.remote_url, :class => "left")
  end

  def image_two
    image_tag(page_section.image_two.remote_url, :class => "right")
  end

  def image_hint
    "Should be at least #{dimensions.join(' by ')} pixels."
  end

  protected

  def dimensions
    [300, 300]
  end

  def sortable_content
    available? ? [image_tag(page_section.image_one.remote_url, :class => "left", :width => 50, :height => 50), image_tag(page_section.image_two.remote_url, :class => "right", :width => 50, :height => 50)].join.html_safe : 'processing'
  end
end