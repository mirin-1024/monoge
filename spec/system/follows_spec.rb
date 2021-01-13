require 'rails_helper'

RSpec.describe "Follows", type: :system do
  subject { page }

  let!(:user) { create(:user) }
  let(:user_count) { 5 }
  let(:other_users) { create_list(:test_user, user_count) }

  before do
    other_users.each do |other_user|
      user.active_relationships.create!(followed_id: other_user.id)
      user.passive_relationships.create!(follower_id: other_user.id)
    end
  end

  describe "フォローしている人数を表示" do
    context "ログインしていない場合" do
      before { visit following_user_path(user) }

      example "ログインページへリダイレクト" do
        is_expected.to have_current_path login_path
      end
    end

    context "ログインしている場合" do
      before do
        sign_in(user)
        visit following_user_path(user)
      end

      example "フォロー人数が適切である" do
        expect(user.following.count).to eq user_count
      end

      example "フォローしているユーザーのリンクが表示される" do
        user.following.each do |u|
          is_expected.to have_link u.name, href: user_path(u)
        end
      end
    end
  end

  describe "フォロワーの人数を表示" do
    context "ログインしていない場合" do
      before { visit followers_user_path(user) }

      example "ログインページへリダイレクト" do
        is_expected.to have_current_path login_path
      end
    end

    context "ログインしている場合" do
      before do
        sign_in(user)
        visit followers_user_path(user)
      end

      example "フォロワーの数が適切である" do
        expect(user.followers.count).to eq user_count
      end

      example "フォロワーのリンクが表示される" do
        user.followers.each do |u|
          is_expected.to have_link u.name, href: user_path(u)
        end
      end
    end
  end

  describe "フォローボタン" do
    before do
      sign_in(user)
      visit user_path(other_users.last.id)
    end

    context "Unfollowをクリック" do
      example "フォローしている人数が1人減る", :aggregate_failures do
        expect do
          click_button "Unfollow"
          is_expected.to_not have_link "Unfollow"
        end.to change(user.following, :count).by(-1)
      end
    end

    context "Followをクリック" do
      before { click_button "Unfollow" }

      example "フォローしている人数が1人増える", :aggregate_failures do
        expect do
          click_button "Follow"
          is_expected.to_not have_link "Follow"
        end.to change(user.following, :count).by(1)
      end
    end
  end
end
