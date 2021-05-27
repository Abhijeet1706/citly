class LinksController < ApplicationController
  before_action :load_link, only: [:update, :show]

  def index
    @links = Link.all
    respond_to do |format|
      format.html
      format.json {render status: :ok, json: { links: @links }}
      format.csv { send_data @links.to_csv, filename: "links-#{Date.today}.csv" }
    end
    
  end

  def create
    @link = Link.new(link_params)
    @link.short_link = generate_short_link()
    if @link.save
      render status: :ok, json: {
        notice: t("successfully_created"),
      }
    else
      errors = @link.errors.full_messages
      render status: :unprocessable_entity, json: { errors: errors }
    end
  end

  def show
    @link.increment!(:click)
    if @link.save
      render status: :ok, json: { link: @link }
    else
      errors = @link.errors.full_messages
      render status: :unprocessable_entity, json: { errors: errors }
    end
  end

  def update
    if @link.update_attribute(:pinned, !@link.pinned)
      render status: :ok, json: {
               message: t("successfully_updated"),
             }
    else
      errors = @link.errors.full_messages
      render status: :unprocessable_entity, json: { errors: errors }
    end
  end

  private

  def link_params
    params.require(:link).permit(:long_link)
  end

  def load_link
    @link = Link.find(params[:id])
  rescue ActiveRecord::RecordNotFound => errors
    render json: { errors: errors }
  end

  def generate_short_link
    "#{request.base_link}/#{rand(36 ** 8).to_s(36)}"
  end
end