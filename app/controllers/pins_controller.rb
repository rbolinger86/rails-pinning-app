class PinsController < ApplicationController
  before_action :require_login, except: [:show, :show_by_name]

  def index
    @pins = Pin.all
  end

  def show
    @pin = Pin.find(params[:id])
    @users = @pin.users
  end

  def show_by_name
    @pin = Pin.find_by_slug(params[:slug])
    @users = @pin.users
    render :show
  end

  def new
    @pin = Pin.new
    @pin.pinnings.build
  end

  def create
    pin = Pin.new(pin_params)
    if pin.save
      pin.pinnings.create(user: current_user)
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

  def repin
    @pin = Pin.find(params[:id])
    @pin.pinnings.create(user: current_user)
    redirect_to user_path(current_user)
  end

  def destroy
    @pin = Pin.find(params[:id])
    @pin.pinnings.delete_all
    @pin.delete
    respond_to do |format|
      format.html { redirect_to boards_path, notice: 'Pin was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def pin_params
    params.require(:pin).permit(:title, :url, :slug, :text, :category_id, :image, :user_id)
  end
end
