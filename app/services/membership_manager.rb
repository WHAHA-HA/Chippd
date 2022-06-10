class MembershipManager
  attr_reader :page, :customer_id, :key, :membership, :access_required

  def initialize(page, customer_id, key, access_required = true)
    @page = page
    @customer_id = customer_id
    @key = key
    @access_required = access_required
  end

  def verify!
    if exists? || available_and_joined?
      log_page_view!
      true
    else
      false
    end
  end

  def exists?
    fetch_membership
  end

  def cancel!
    membership.destroy
  end

  protected

  def available_and_joined?
    available? && join!
  end

  # Protected: Fetch a membership based on the information passed in.
  #
  # Our base requirements for fetching a page membership are:
  #   * customer_id matches
  #   * access is true if access is required
  #   * key matches if the page is private
  #
  # The second condition is based on the optional access_required argument
  # this class takes. The scenario where access required would be false is
  # when a member has elected to delete the page from their app. In this case,
  # it shouldn't matter if the page owner has revoked their access or not,
  # the user has the right to remove their membership as well.
  #
  # The last condition is to ensure that only one member can make use of a
  # given qrcode value to access the page. Otherwise, any member of a flock
  # page could gain access with any matching code associated with said page.
  def fetch_membership
    scope = page.memberships.where(:customer_id => customer_id)
    scope = scope.where(:access => true) if access_required
    scope = scope.where(:key => key) if private_page?
    @membership = scope.first
  end

  def product_type
    @product_type ||= page.chippd_product_type
  end

  def private_page?
    product_type.private?
  end

  def available?
    !unavailable?
  end

  def unavailable?
    customer_access_revoked? || fixed_quantity_used? || key_already_used_for_private_page?
  end

  # Protected: Is the member limit, if it exists, met already?
  #
  # Does the product type have a fixed quantity, and
  # does the number of current page members equal the
  # membership limit imposed by the product type?
  def fixed_quantity_used?
    product_type.fixed_quantity? && (page.members.length == product_type.fixed_quantity)
  end

  def key_already_used_for_private_page?
    product_type.private? && key_already_paired_with_another_customer?
  end

  def key_already_paired_with_another_customer?
    page.memberships.excludes(:customer_id => customer_id).where(:key => key).first ? true : false
  end

  def customer_access_revoked?
    page.memberships.where(:customer_id => customer_id).where(:access => false).first ? true : false
  end

  def join!
    if exists?
      false
    else
      @membership = page.memberships.create(:customer_id => customer_id, :key => key, :privacy => product_type.privacy)
    end
  end

  def log_page_view!
    membership.log_page_view!
  end
end