class PinsController < ApplicationController

  def index
    @pins = Pin.all
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
    if pin.title.to_s.chars.length == pin.title.to_s.gsub(/[^\w\s]/i, '').chars.length
      @pin = Pin.create(pin_params)
      pin.save
      render :show
    else
      @error = "Sorry, your input was invalid. Please try again!"
      @pin = pin
      render :new
    end
  end

  private

  def pin_params
    params.require(:pin).permit(:title, :url, :slug, :text, :resource_type, :category_id)
  end
end
