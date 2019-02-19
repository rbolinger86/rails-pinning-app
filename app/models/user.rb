class User < ActiveRecord::Base
  def self.authenticate(email, password)
    if User.find_by_email(email) && User.find_by_password(password)
      user = @user
    else
      user = nil
    end
  end
end
