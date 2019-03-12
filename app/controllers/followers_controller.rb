class FollowersController < ApplicationController
  before_action :set_follower, only: [:update]
  before_action :require_login, only: [:index, :new, :update]

  # GET /followers
  # GET /followers.json
  def index
    @followers = Follower.all
    @followed = current_user.followed
  end

  # GET /followers/1
  # GET /followers/1.json

  # GET /followers/new
  def new
      @follower = Follower.new
      @users = current_user.not_followed
  end

  # GET /followers/1/edit

  # POST /followers
  # POST /followers.json
  def create
    @follower = Follower.new(follower_params)

    respond_to do |format|
      if @follower.save
        @followed = current_user.followed
        format.html { redirect_to followers_path, notice: 'Follower was successfully created.' }
        format.json { render :show, status: :created, location: @follower }
      else
        format.html { render :new }
        format.json { render json: @follower.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /followers/1
  # PATCH/PUT /followers/1.json
  def update
    respond_to do |format|
      if @follower.update(follower_params)
        format.html { redirect_to @follower, notice: 'Follower was successfully updated.' }
        format.json { render :show, status: :ok, location: @follower }
      else
        format.html { render :edit }
        format.json { render json: @follower.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /followers/1
  # DELETE /followers/1.json

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_follower
      @follower = Follower.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def follower_params
      params.require(:follower).permit(:user_id, :follower_id)
    end
end
