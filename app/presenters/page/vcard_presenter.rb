class VcardPresenter < PageSectionPresenter
  def name
    content_tag(:h1, (url? ? link_to_url.html_safe : page_section.name), :class => 'fn')
  end

  def link_to_url
    link_to(page_section.name, page_section.url, :class => 'url')
  end

  def image
    image_url = page_section.image.present? ? page_section.image.thumb('150x150#').url : 'vcard-default.png'
    image_tag(image_url, :alt => "Photo of #{page_section.name}", :class => 'photo')
  end

  def link_to_map
    link_to('Map', google_maps_url, :class => 'map', :target => 'blank', 'data-icon' => '@', 'aria-hidden' => 'true') if page_section.link_to_map
  end

  def link_to_vcard
    link_to('vCard', download_vcard_my_chippd_page_section_path(page_section.page, page_section), :class => 'download', 'data-icon' => 'U', 'aria-hidden' => 'true') if page_section.link_to_vcard
  end

  def company
    handle_none(page_section.company) do
      content_tag(:div, page_section.company, :class => 'org')
    end
  end

  def email
    mail_to(page_section.email, nil, :class => 'email')
  end

  def address
    content_tag(:div, :class => 'adr') do
      [street, [city, state].compact.join(', '), postal_code, country].join("\n").html_safe
    end
  end

  def street
    handle_none(page_section.address) do
      content_tag(:div, page_section.address, :class => 'street-address')
    end
  end

  def city
    handle_none(page_section.city) do
      content_tag(:span, page_section.city, :class => 'locality')
    end
  end

  def state
    handle_none(page_section.state) do
      content_tag(:span, page_section.state, :class => 'region')
    end
  end

  def postal_code
    handle_none(page_section.postal_code) do
      content_tag(:span, page_section.postal_code, :class => 'postal-code')
    end
  end

  def country
    handle_none(page_section.country) do
      content_tag(:div, page_section.country, :class => 'country-name')
    end
  end

  def phone
    handle_none(page_section.phone) do
      content_tag(:div, page_section.phone, :class => 'tel')
    end
  end

  def to_vcf
    Vpim::Vcard::Maker.make2 do |maker|
      maker.add_name do |name|
        name.given = page_section.name
      end

      maker.add_addr do |addr|
        addr.preferred = true
        addr.location = 'home'
        addr.street = page_section.address
        addr.locality = page_section.city
        addr.region = page_section.state
        addr.postalcode = page_section.postal_code
        addr.country = page_section.country
      end

      maker.add_tel(page_section.phone) if page_section.phone.present?
      maker.add_email(page_section.email) { |e| e.location = 'home' }
    end.to_s
  end

  def vcf_filename
    "#{page_section.name.parameterize}.vcf"
  end
protected

  def url?
    page_section.url.present?
  end

  def company?
    page_section.company.present?
  end

  def google_maps_url
    "http://maps.google.com/?q=#{map_query_string}"
  end

  def map_query_string
    URI.escape([page_section.address, page_section.city, page_section.state, page_section.postal_code, page_section.country].compact.join(' ').strip)
  end

  def sortable_content
    page_section.name
  end
end