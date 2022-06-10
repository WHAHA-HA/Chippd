class MyChippd::RedemptionsController < MyChippd::BaseController
  layout 'simple'
  before_filter :ensure_code_param, :only => :verify
  # before_filter :ensure_chippd_product_type_id_param, :only => :create, :if => :code_is_retail?

  def index
    @gift_code = params[:gift_code] || params[:code]
    @chippd_product_types = ChippdProductTypePresenter.from_collection(ChippdProductType.all, view_context)
  end

  def create
    if RedeemCode.call(current_customer.to_param, params[:code], params[:chippd_product_type_id])
      redirect_to my_chippd_pages_url, :notice => "Your code has been redeemed!"
    else
      flash[:error] = "Sorry, we couldn't redeem that code."
      redirect_to my_chippd_redemptions_url
    end
  end

  def verify
    if code_verified?
      render :json => code_verifier, :status => 200
    else
      head 422
    end
  end

  protected

  def ensure_code_param
    unless params[:code].present?
      flash[:error] = "Please enter a code to redeem."
      redirect_to my_chippd_redemptions_url and return
    end
  end

  def ensure_chippd_product_type_id_param
    unless params[:chippd_product_type_id]
      flash[:error] = "Please choose a Chipp'd Product Type to redeem your code."
      redirect_to my_chippd_redemptions_url(:code => params[:code]) and return
    end
  end

  def code_verifier
    @verifier ||= VerifyRedeemCode.call(params[:code])
  end

  def code_verified?
    code_verifier.pass?
  end

  def code_is_retail?
    code_verifier.type.retail?
  end
end