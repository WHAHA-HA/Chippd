class BabysFirstPresenter < PageSectionPresenter
  delegate :photo?, :video?, :to => :page_section

  def caption
    handle_none(page_section.caption) do
      content_tag(:figcaption, page_section.caption)
    end
  end

  def image
    image_tag(page_section.image.remote_url, :width => 585, :height => 404, :alt => "Baby Photo")
  end

  def video_embed
    content_tag(:video, :class => 'sublime', :width => 551, :height => 310, :poster => page_section.poster.remote_url, :preload => 'none', 'data-settings' => player_settings) do
      page_section.versions.each do |version|
        concat(source_tag_for(version))
      end
    end
  end

  protected

  def source_tag_for(version)
    %{\n<source src="#{version.file.remote_url}" type='#{version.codec}' />}.html_safe
  end

  def sortable_content
    page_section.caption? ? page_section.caption : 'Baby First'
  end

  def uid
    [page_section.page.customer_id, page_section.page.to_param, page_section.to_param].join('-')
  end

  def player_settings
    {
      'autoresize' => 'fit',
      'player-kit' => '2',
      'uid' => uid
    }.collect { |i| i.join(':') }.join('; ')
  end
end
