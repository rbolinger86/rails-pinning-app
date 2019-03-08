require 'spec_helper'
RSpec.describe BoardsController do

  before(:each) do
    @user = FactoryGirl.create(:user)
    @board = @user.boards.first
    login(@user)
  end

  after(:each) do
    if !@user.destroyed?
      @user.pins.destroy_all
      @user.pinnings.destroy_all
      @user.boards.destroy_all
      @user.destroy
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
    it 'assigns an instance variable to a new board' do
      post :create
      expect(assigns[:board].present?).to be(true)
    end
    it 'redirects to the login page if user is not logged in' do
      @user.destroy
      get :new
      response.should render_template("login")
    end
  end

  describe "POST create" do
    before(:each) do
      @board_hash = {
        name: "My Pins!"
      }
    end

    after(:each) do
      board = Board.find_by_name("My Pins!")
      if board.present?
        board.destroy
      end
    end

    it 'responds with a redirect' do
      post :create
      expect(response.redirect?).to be(true)
    end
    it 'creates a board' do
      post :create, board: @board_hash
      expect(Board.find_by_name("My Pins!").present?).to be(true)
    end
    it 'redirects to the show view' do
      post :create, board: @board_hash
      expect(response).to redirect_to(board_url(assigns(:board)))
    end
    it 'redisplays new form on error' do
      @board_hash[:hash] = nil
      post :create
      expect(response).to render_template(:new)
    end
    it 'redirects to the login page if user is not logged in' do
      @user.destroy
      get :new
      response.should render_template("login")
    end
  end

  describe "GET #show" do
    it "assigns the requested board" do
      post :create, board: @board_hash
      get :show
      assigns(:board).should eq(board)
    end
    it "assigns the @pins variable with the board's pins" do
      post :create, board: @board_hash
      assigns(:pins).should eq(board.pins)
    end
  end
end
