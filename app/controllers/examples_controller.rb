class ExamplesController < ApplicationController
  helper_method :preview?, :back_from_preview_path, :current_customer, :editing?

  def show
    @page = PagePresenter.new(Page.find(params[:id]), view_context)
    render '/my_chippd/pages/show', :layout => false
  end

  private

  def preview?
    true unless @page.page.id == "54d274234c06fcc008000001"
  end

  def back_from_preview_path
    case params[:key]
      when :love, :flock, :story then how_it_works_path
    else
      root_path
    end
  end

  # Set the current_customer to test@chippd.com.
  # For use with the wedding page.
  def current_customer
    @current_customer ||= Customer.find('5334b3296ac2747bbb000001')
  end

  def editing?
    false
  end
end
