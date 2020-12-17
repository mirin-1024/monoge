require 'rails_helper'

RSpec.describe "Likes", type: :system do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:test_user) }
  let!(:other_user_micropost) { create(:test_micropost, user: other_user) }
  @user_likes_count = 1
  before { user.active_relationships.create!(followed_id: other_user.id) }

  context "いいねをする場合" do
    before {
      sign_in(user)
      visit root_path
    }
    example "正常にいいねができる" do
      expect do
        page.first(".like_btn").click
      end.to change(Like, :count).by(1)
    end
    example "いいねの数が増える" do
      expect(other_user.microposts.last.likes_count).to eq 0
      page.first(".like_btn").click
      expect(other_user.microposts.last.likes_count).to eq 1
    end
  end
  context "いいねを取り消す場合" do
    before {
      sign_in(user)
      visit root_path
      page.first(".like_btn").click
    }
    example "正常にいいねが取り消せる" do
      expect do
        page.first(".like_btn").click
      end.to change(Like, :count).by(-1)
    end
    example "いいねの数が減る" do
      expect(other_user.microposts.last.likes_count).to eq 1
      page.first(".like_btn").click
      expect(other_user.microposts.last.likes_count).to eq 0
    end
  end
end
