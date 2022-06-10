class SocialPresenter < PageSectionPresenter
  Social::NETWORKS.each do |network|
    define_method(:"#{network}_list_item") do
      handle_none(page_section.send(:"#{network}_url")) do
        content_tag(:li, self.send(:"link_to_#{network}"), :class => network)
      end
    end

    define_method(:"link_to_#{network}") do
      link_to(link_text_for(network), page_section.send(:"#{network}_url"))
    end
  end

  protected

  def link_text_for(network)
    I18n.t("page.sections.social.networks.#{network}.name")
  end
end