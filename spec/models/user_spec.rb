require 'rails_helper'

RSpec.describe User, type: :model do
  context "create valid user" do
    before { @user = build(:user) }
    it "valid user" do
      expect(@user).to be_valid
    end
  end

  context "create invalid user" do
    before { @user = build(:user, name: "invalid user",
                                 email: "a" * 39 + "@example.com",
                                 password: "password",
                                 password_confirmation: "passwor" ) }
    it "reject invalid user" do
      expect(@user).not_to be_valid
    end
  end
end
