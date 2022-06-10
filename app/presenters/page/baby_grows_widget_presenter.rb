class BabyGrowsWidgetPresenter < PageSectionPresenter

  def milestones
    page_section.milestones.collect { |milestone| MilestonePresenter.new(milestone, @template) }
  end

end
