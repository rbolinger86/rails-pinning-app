require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

RSpec.describe FollowersController do
  before(:each) do
    @user = FactoryGirl.create(:user_with_followees)
    @board = @user.boards.first
    login(@user)
  end
  after(:each) do
    if !@user.destroyed?
      Follower.where("follower_id=?", @user.id).first.destroy
      @user.destroy
    end
  end

  describe "GET index" do
    it 'renders the index template' do
      get :index
      expect(response).to render_template("index")
    end
    it 'populates @followed with all followed users' do
      get :index
      assigns(:followed).should eq(current_user.followed)
    end
    it 'redirects to the login page if user is not logged in' do
      @user.destroy
      get :new
      response.should render_template("login")
    end
  end

  describe "GET new" do
    it 'responds with successfully' do
      get :new
      expect(response.success?).to be(true)
    end
    it 'renders the new view' do
      get :new
      expect(response).to render_template(:new)
    end
    it 'assigns @users to equal the users not followed by @user' do
      get :index
      assigns(:users).should eq(@user.not_followed)
    end
    it 'redirects to the login page if user is not logged in' do
      @user.destroy
      get :new
      response.should render_template("login")
    end
  end

  describe "POST create" do
    before(:each) do
      @follower_user = FactoryGirl.create(:user)
      @follower_hash = {
        user_id: @user.id,
        follower_id: @follower_user.id
      }
    end

    after(:each) do
      follower = Follower.where("user_id=? AND follower_id=?", @user.id, @follower_user.id)
      if !follower.empty?
        follower.destroy_all
        @follower_user.destroy
      end
    end

    it 'responds with a redirect' do
      post :create
      expect(response.redirect?).to be(true)
    end
    it 'creates a follower' do
      post :create, follower: @follower_hash
      expect(Follower.find_by_full_name("Skillcrush Coder").present?).to be(true)
    end
    it 'redirects to the index view' do
      post :create, follower: @follower_hash
      expect(response).to redirect_to(:index)
    end
    it 'redirects to the login page if user is not logged in' do
      @user.destroy
      get :new
      response.should render_template("login")
    end
  end
end