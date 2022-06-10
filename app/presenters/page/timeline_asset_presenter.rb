class TimelineAssetPresenter < PageSectionPresenter
  presents :timeline_asset
  delegate :timeframe, :heading, :description, :track_name, :photo?, :video?, :audio?, :to => :timeline_asset

  def image
    image_tag(timeline_asset.image.remote_url, :alt => "photo")
  end

  def video_embed
    content_tag(:video, :class => 'sublime', :width => 551, :height => 310, :poster => timeline_asset.poster.remote_url, :preload => 'none', 'data-settings' => player_settings) do
      timeline_asset.versions.each do |version|
        concat(source_tag_for(version))
      end
    end
  end

  def link_to_track
    link_to(timeline_asset.audio_file.remote_url, :class => 'title') do
      @template.concat(@template.content_tag(:h4, timeline_asset.track_name))
    end
  end

  protected

  def source_tag_for(version)
    %{\n<source src="#{version.file.remote_url}" type='#{version.codec}' />}.html_safe
  end

  def sortable_content
    timeline_asset.caption? ? timeline_asset.caption : 'Timeline'
  end

  def uid
    #[page_section.page.customer_id, page_section.page.to_param, page_section.to_param].join('-')
    1
  end

  def player_settings
    {
      'autoresize' => 'fit',
      'player-kit' => '2',
      'uid' => uid
    }.collect { |i| i.join(':') }.join('; ')
  end

end
