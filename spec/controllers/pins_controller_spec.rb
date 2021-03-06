require 'spec_helper'
RSpec.describe PinsController do

  before(:each) do
    @user = FactoryGirl.create(:user_with_boards)
    @board_pinner = BoardPinner.create(user: @user, board: FactoryGirl.create(:board))
    login(@user)
  end

  after(:each) do
    if !@user.destroyed?
      @user.boards.destroy_all
      @user.destroy
    end
  end

  describe "GET index" do
    it 'renders the index template' do
      get :index
      expect(response).to render_template("index")
    end

    it 'populates @pins with all pins' do
      get :index
      expect(assigns[:pins]).to eq(Pin.all)
    end
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
    it 'assigns an instance variable to a new pin' do
      get :new
      expect(assigns(:pin)).to be_a_new(Pin)
    end
    it 'assigns @pinnable_boards to all pinnable boards' do
      get :new
      assigns(:pinnable_boards).should eq(@user.boards+@board_pinner.boards)
    end
  end

  describe "POST create" do
    before(:each) do
      @pin_hash = {
        title: "Rails Wizard",
        url: "http://railswizard.org",
        slug: "rails-wizard",
        text: "A fun and helpful Rails Resource"}
    end
  end

    after(:each) do
      pin = Pin.find_by_slug("rails-wizard")
      if !pin.nil?
        pin.destroy
      end
    end

    it 'responds with a redirect' do
      post :create, pin: @pin_hash
      expect(response.redirect?).to be(true)
    end
    it 'creates a pin' do
      post :create, pin: @pin_hash
      expect(Pin.find_by_slug("rails-wizard").present?).to be(true)
    end
    it 'redirects to the show view' do
      post :create, pin: @pin_hash
      expect(response).to redirect_to(pin_url(assigns(:pin)))
    end
    it 'redisplays new form on error' do
      # The title is required in the Pin model, so we'll
      # delete the title from the @pin_hash in order
      # to test what happens with invalid parameters
      @pin_hash.delete(:title)
      post :create, pin: @pin_hash
      expect(response).to render_template(:new)
    end
    it 'assigns the @errors instance variable on error' do
      # The title is required in the Pin model, so we'll
      # delete the title from the @pin_hash in order
      # to test what happens with invalid parameters
      @pin_hash.delete(:title)
      post :create, pin: @pin_hash
      expect(assigns[:errors].present?).to be(true)
    end
    it 'pins to a board for which the user is a board_pinner' do
      @pin_hash[:pinnings_attributes] = []
      board = @board_pinner.board
      @pin_hash[:pinnings_attributes] << {board_id: board.id, user_id: @user.id}
      post :create, pin: @pin_hash
      pinning = board.pinning
      expect(Board.find_by_pinning(pinning)).to eq(@board_pinner.board)
      if pinning.present?
        pinning.destroy_all
      end
    end

    describe "GET edit" do
      it 'responds with successfully' do
        get :new
        expect(response.success?).to be(true)
      end
      it 'renders the new view' do
        get :new
        expect(response).to render_template(:new)
      end
      it 'assigns an instance variable to a new pin' do
        get :new
        expect(assigns(:pin)).to be_a_new(Pin)
      end
    end

    describe "PUT update" do
      it 'responds with successfully' do
        get :new
        expect(response.success?).to be(true)
      end
      it 'renders the new view' do
        get :new
        expect(response).to render_template(:new)
      end
      it 'assigns an instance variable to a new pin' do
        get :new
        expect(assigns(:pin)).to be_a_new(Pin)
      end
    end

    describe "POST repin" do
      before(:each) do
        @user = FactoryGirl.create(:user)
        login(@user)
        @pin = FactoryGirl.create(:pin)
      end

      after(:each) do
        pin = Pin.find_by_slug("rails-wizad")
        if !pin.nil?
          pin.destroy
        end
        logout(@user)
      end

      it 'responds with a redirect' do
        post :create, pin: @pin_hash
        expect(response.redirect?).to be(true)
      end
      it 'creates a user.pin' do
        post :create, pin: @pin_hash
        expect(assigns[:user.pin].present?).to be(true)
      end
      it 'redirects to the user show page' do
        post :create, pin: @pin_hash
        expect(response).to render_template(:show)
      end
      it 'creates a pinning to a board on which the user is a board_pinner' do
        @pin_hash = {
          title: @pin.title,
          url: @pin.url,
          slug: @pin.slug,
          text: @pin.text,
          category_id: @pin.category_id
        }
        board = @board_pinner.board
        @pin_hash[:pinning] = {board_id: board.id}
        post :repin, id: @pin.id, pin: @pin_hash
        pinning = board.pinning
        expect(Board.find_by_pinning(pinning)).to eq(@board_pinner.board)
        if pinning.present?
          pinning.destroy_all
        end
      end
  end
