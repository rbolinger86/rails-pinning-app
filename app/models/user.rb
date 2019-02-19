class User < ActiveRecord::Base
  def self.authenticate(email, password)
    user = User.find_by_email(email)
      if user.password == User.find_by_password(password)
        user = @user
      else
        user = nil
      end
  end
end
