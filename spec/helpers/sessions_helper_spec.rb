require 'rails_helper'

RSpec.describe SessionsHelper, type: :helper do
  let(:user) { create(:user) }

  describe "current_user" do
    before { remember(user) }

    example "sessionがnilの場合、正しいユーザーを返す" do
      expect(current_user).to eq user
      expect(logged_in?).to be_truthy
    end

    example "remember_digestが不適切な場合、nilを返す" do
      user.update_attribute(:remember_digest, User.digest(User.new_token))
      expect(current_user).to eq nil
    end
  end
end
