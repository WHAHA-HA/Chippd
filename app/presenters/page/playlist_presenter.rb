class PlaylistPresenter < PageSectionPresenter

  def title
    handle_none(page_section.title) do
      content_tag(:h1, page_section.title)
    end
  end

  def tracks
    page_section.tracks.collect { |track| TrackPresenter.new(track, @template) }
  end

  protected

  def sortable_content
    page_section.title? ? page_section.title : 'Playlist'
  end
end