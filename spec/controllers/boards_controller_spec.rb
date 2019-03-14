require 'spec_helper'
RSpec.describe BoardsController do

  before(:each) do
    @user = FactoryGirl.create(:user_with_boards_and_followers)
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
      assigns(:board).should eq(board)
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

  describe "GET #edit" do
    it 'responds successfully' do
      get :edit
      expect(response.success?).to be(true)
    end
    it 'renders the edit view' do
      get :edit
      expect(response).to render_template(:edit)
    end
    it 'assigns an instance variable to a new board' do
      get :edit
      assigns(:board).should eq(board)
    end
    it 'redirects to the login page if user is not logged in' do
      @user.destroy
      get :edit
      response.should render_template("login")
    end
    it 'sets @followers to the user\'s followers' do
      get :edit
      assigns(:followers).should eq(@user.followers)
    end
  end

  describe "PUT #update" do
    before(:each) do
      @board_hash = {
        name: @board.name
      }
    end

    it 'responds with a redirect' do
      @board_hash[:name] = "New Name"
      put :update, id: @board.id, board: @board_hash
      expect(response.redirect?).to be(true)
    end
    it 'updates a board' do
      @board_hash[:name] = "New Name"
      put :update, id: @board.id, board: @board_hash
      expect(@board.reload.name).to eq("New Name")
    end
    it 'redirects to the show view' do
      @board_hash[:name] = "New Name"
      put :update, id: @board.id, board: @board_hash
      expect(response).to redirect_to(:show)
    end
    it 'redisplays edit form on error' do
      # The name is required in the Board model, so we'll
      # set the name in the @board_hash to blank in order
      # to test what happens with invalid parameters
      @board_hash[:name] = ""
      put :update, id: @board.id, board: @board_hash
      expect(response).to render_template(:edit)
    end
    it 'assigns the @errors instance variable on error' do
      # The name is required in the Board model, so we'll
      # set the name in the @board_hash to blank in order
      # to test what happens with invalid parameters
      @board_hash[:name] = ""
      put :update, id: @board.id, board: @board_hash
      expect(assigns[:board].errors.any?).to be(true)
    end
    it 'redirects to the login page if user is not logged in' do
      @user.destroy
      put :update, id: @board.id, board: @board_hash
      response.should render_template("login")
    end
    it 'creates a BoardPinning' do
      # This one is tricky, but see if you can understand what's going on
      # We get the user's first follower - this is the one we want to let pin on @board
      user_to_let_pin = @user.followers.first

      # Now we're updating the hash we pass in to add
      # board_pinners_attributes with our user_id
      @board_hash[:board_pinners_attributes] = []
      @board_hash[:board_pinners_attributes] << {user_id: user_to_let_pin.id}

      put :update, id: @board.id, board: @board_hash
      # Then we expect this record to have been created
      board_pinner = BoardPinner.where("user_id=? AND board_id=?", user_to_let_pin.id, @board.id)
      expect(board_pinner.present?).to be (true)
      # Let's clean up here
      if board_pinner.present?
        board_pinner.destroy_all
      end
    end
  end

  describe "GET index" do
    it "assigns all pinnable boards as @boards" do
      board = Board.create, board: @board_hash
      get :index, {}, valid_session
      assigns(:boards).should eq([user.pinnable_boards])
    end
  end
end
