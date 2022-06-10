class MembershipPresenter < BasePresenter
  presents :membership

  def last_viewed_at
    membership.last_viewed_at ? membership.last_viewed_at.stamp('10/15') : ''
  end

  def access_on?
    membership.access ? ' active' : ''
  end

  def access_off?
    membership.access ? '' : ' active'
  end

  def customer_name
    customer.full_name
  end

  def customer
    membership.customer
  end

  def link_to_remove
    link_to('remove', my_chippd_page_membership_path(membership.page, membership), 'aria-hidden' => 'true', 'data-icon' => 'D', :method => :delete, :confirm => "Are you sure you want to remove this person's access?")
  end

  def to_param
    membership.to_param
  end

  def to_html
    raw(%{#{customer_name} #{link_to_remove}})
  end

  def to_li
    content_tag(:li, to_html)
  end
end