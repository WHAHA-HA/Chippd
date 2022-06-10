class EmbeddedAudioPresenter < PageSectionPresenter
  def caption
    handle_none(page_section.caption) do
      content_tag(:p, page_section.caption, :class => "caption")
    end
  end

  def audio_embed
    embed_codes[page_section.audio_type].html_safe
  end

  protected

  def audio_id
    page_section.audio_id
  end

  def embed_codes
    {
      :soundcloud => %{<iframe width="100%" height="450" scrolling="no" frameborder="no" src="https://w.soundcloud.com/player/?url=#{audio_id}&amp;auto_play=false&amp;hide_related=false&amp;visual=true"></iframe>}
    }
  end

  def sortable_content
    page_section.caption? ? page_section.caption : 'Audio'
  end
end

