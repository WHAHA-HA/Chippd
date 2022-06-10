class EmbeddedVideoPresenter < PageSectionPresenter
  def caption
    handle_none(page_section.caption) do
      content_tag(:p, page_section.caption, :class => "caption")
    end
  end

  def video_embed
    embed_codes[page_section.video_type].html_safe
  end

  protected

  def video_id
    page_section.video_id
  end

  def embed_codes
    {
      :vimeo => %{<iframe src="//player.vimeo.com/video/#{video_id}?title=0&amp;byline=0&amp;portrait=0&amp;color=ffffff" width="500" height="281" frameborder="0" webkitallowfullscreen="" mozallowfullscreen="" allowfullscreen=""></iframe>},
      :youtube => %{<iframe width="500" height="281" src="//www.youtube.com/embed/#{video_id}?enablejsapi=1&amp;autoplay=0&amp;cc_load_policy=0&amp;iv_load_policy=1&amp;loop=0&amp;modestbranding=1&amp;rel=0&amp;showinfo=0&amp;controls=2&amp;autohide=2&amp;theme=dark&amp;color=white&amp;wmode=opaque&amp" frameborder="0" allowfullscreen=""></iframe>}
    }
  end

  def sortable_content
    page_section.caption? ? page_section.caption : 'Video'
  end
end

