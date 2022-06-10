class TrackPresenter < BasePresenter
  presents :track
  delegate :name, :to => :track

  def link_to_track
    link_to(track.file.remote_url, :class => 'title', 'data-impressions-behavior' => 'click') do
      @template.concat(@template.content_tag(:h4, track.name))
    end
  end
end