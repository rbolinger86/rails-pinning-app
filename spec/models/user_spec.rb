require 'spec_helper'

describe User do
  pending "add some examples to (or delete) #{__FILE__}"
end

before(:all) do
  @user = User.create(email: "coder@skillcrush", password: "password")
end

after(:all) do
  if !@user.destroyed?
    @user.destroy
  end
end

it 'authenticates and returns a user when valid email and password passed in' do
end

it { should validate_presence_of(:first_name) }
