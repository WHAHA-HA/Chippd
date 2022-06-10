class TimelinePresenter < PageSectionPresenter
  delegate :name_one, :name_two, :to => :page_section

  def timeline_assets
    page_section.timeline_assets.collect { |asset| TimelineAssetPresenter.new(asset, @template) }
  end

  def wedding_date
    page_section.wedding_date.stamp('January 30, 2013')
  end

  def wedding_date?
    page_section.wedding_date.present?
  end

end
