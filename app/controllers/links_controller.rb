class LinksController < ApplicationController
  before_action :load_link, only: :update
  before_action :check_link_presence, only: :create 
  
  def index
    links = Link.all
    respond_to do |format|
      format.html {render status: :ok, json:  links.organize()}
      format.csv { send_data links.to_csv, filename: "links-#{Date.today}.csv" }
    end   
  end

  def create
    hash = generate_hash(link_params[:link])
    link = Link.new(link_params.merge(shortened: hash))
    if link.save
      render status: :ok, json: {notice: "Link shortened"}
    else
      render status: :unprocessable_entity,
             json: { error: link.errors.full_messages.to_sentence }
    end
  end

  def update
    if @link.update(link_params)
      render status: :ok, json: {}
    else
      render status: :unprocessable_entity,
             json: { error: @link.errors.full_messages.to_sentence }
    end
  end

  private 

  def link_params    
    params.require(:link).permit(:link, :status )
  end

  def load_link
    @link = Link.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { error: e }, status: :not_found
  end

  def generate_hash(string)
    index = 0
    while index <= 58 do
      hash = (Digest::SHA256.hexdigest string)[index,6]
      return hash unless Link.find_by(shortened: hash)
      index += 7 
    end 
    render status: :unprocessable_entity,
             json: { error: "Couldn't Shortern the Link"}
  end

  def check_link_presence
    link = link_params[:link]
    if Link.find_by(link: link)
      render status: :unprocessable_entity,
             json: { error: "Link already present"}
    end
  end
end
