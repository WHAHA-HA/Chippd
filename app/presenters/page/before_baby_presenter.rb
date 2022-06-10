class BeforeBabyPresenter < PageSectionPresenter

  def baby_images
    page_section.baby_images.collect { |baby_image| BabyImagePresenter.new(baby_image, @template) }
  end

end
