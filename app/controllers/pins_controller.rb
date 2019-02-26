class PinsController < ApplicationController
  before_action :require_login, except: [:show, :show_by_name, :index]

  def index
    @pins = current_user.pins
  end

  def show
    @pin = Pin.find(params[:id])
  end

  def show_by_name
    @pin = Pin.find_by_slug(params[:slug])
    render :show
  end

  def new
    @pin = Pin.new
  end

  def create
    pin = Pin.new(pin_params)
    if pin.save
      redirect_to pin
    else
      @pin = pin
      render :new
    end
  end

  def edit
    @pin = Pin.find(params[:id])
    render :edit
  end

  def update
    pin = Pin.find(params[:id])
    if pin.update_attributes(pin_params)
      redirect_to pin
    else
      @pin = pin
      render :edit
    end
  end

  private

  def pin_params
    params.require(:pin).permit(:title, :url, :slug, :text, :category_id, :image, :user_id)
  end
end
