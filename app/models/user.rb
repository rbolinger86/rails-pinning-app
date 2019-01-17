class User < ActiveRecord::Base
  def self.authenticate(email, password)
    User.find(params[:email]) && User.find(params[:password])
  end
end
