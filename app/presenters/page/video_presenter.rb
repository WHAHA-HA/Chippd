class VideoPresenter < PageSectionPresenter
  def caption
    handle_none(page_section.caption) do
      content_tag(:p, page_section.caption, :class => "caption")
    end
  end

  def video_embed
    content_tag(:video, :class => 'sublime', :width => 551, :height => 310, :poster => page_section.poster.remote_url, :preload => 'none', 'data-settings' => player_settings, 'data-impressions-behavior' => 'click') do
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
    page_section.caption? ? page_section.caption : 'Video'
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

