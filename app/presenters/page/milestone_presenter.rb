class MilestonePresenter < BasePresenter
  presents :milestone
  delegate :age, :weight, :height, :to => :milestone

  def date
    milestone.date.stamp('January 30, 2013')
  end

end
