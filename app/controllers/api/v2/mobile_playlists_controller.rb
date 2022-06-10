class Api::V2::MobilePlaylistsController < Api::V1::BaseController

  def show
    playlist = Page.find(params[:id]).sections.first
    render :json => playlist.to_json, :status => :ok

  rescue Mongoid::Errors::DocumentNotFound => e
    head :not_found
  end

end
