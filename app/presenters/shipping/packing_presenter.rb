class PackingPresenter < BasePresenter
  presents :order

  def info
    content_tag(:ul) do
      if order.shipping_via_ground?
        concat(content_tag(:li, "USPS Flat-rate Shipping"))
      else
        packages = BinPacker.new(order.number_of_units).packages
        packages.each do |p|
          Rails.logger.info(p.inches)
          num = packages.index(p) + 1
          concat(content_tag(:li, "Box ##{num} - #{p.inches.join('in x ')}in - #{p.weight}"))
        end
      end
    end
  end
end