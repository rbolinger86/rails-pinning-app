class User < ActiveRecord::Base
  validates_presence_of :first_name, :last_name, :email, :password
  validates_uniqueness_of :email
  has_many :pinnings
  has_many :pins, through: :pinnings
  has_many :boards
  has_secure_password

  def self.authenticate(email, password)
    @user = User.find_by_email(email)
      if !@user.blank?
        if @user.authenticate(password)
          return @user
        end
      else
        nil
      end
  end

  def followed
    Follower.where("follower_id=?", self.id).map{|f| f.user }
  end
  def not_followed
    User.all - self.followed - [self]
  end
end
