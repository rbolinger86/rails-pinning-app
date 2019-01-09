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
    @pin.errors.add('input', 'must be only alphabetic characters') if @pin.to_s.chars.length > @pin.to_s.gsub(/[^a-z]/i, '').chars.length
    if @pin.errors
      render :show
      @pin = Pin.create(pin_params)
    else
      render :new
      @error = @pin.error
    end
  end

  private

  def pin_params
    params.require(:pin).permit(:title, :url, :slug, :text, :resource_type)
  end
end
