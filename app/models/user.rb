class User < ActiveRecord::Base
  def self.authenticate(email, password)
    if User.find(params[:email]) && User.find(params[:password])
      redirect_to @user.show
    else
      user = nil
    end
  end
end
