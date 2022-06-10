module OrdersHelper
  def unless_for_existing_page(&block)
    @for_existing_page ? render('for_existing_page') : capture(&block)
  end
end