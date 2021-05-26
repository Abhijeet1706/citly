class HomeController < ApplicationController
  before_action :load_link_by_shortened, only: :show

  def index 
    render
  end

  def show
    if @link.present?
      @link.increment!(:clicked)
      redirect_to @link.link
    else
      render
    end
  end

  private
    def load_link_by_shortened
      @link = Link.find_by(shortened: params[:id])
    end
end
