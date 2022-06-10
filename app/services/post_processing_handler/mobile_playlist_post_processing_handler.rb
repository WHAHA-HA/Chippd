class MobilePlaylistPostProcessingHandler < PlaylistPostProcessingHandler

  protected

  def tracks
    section.mobile_tracks
  end

end
