require 'rails_helper'

RSpec.describe "Searches", type: :system do
  subject { page }

  let!(:user) { create(:user) }
  let!(:other_user) { create(:test_user) }
  let!(:micropost) { create(:micropost, user: user) }

  before {
    sign_in(user)
    visit root_path
  }

  context "ユーザーを検索する場合" do
    before {
      select "ユーザー", from: "model"
      fill_in "keyword", with: other_user.name
      find("#search-btn").click
    }

    example "キーワードに一致するユーザーが表示される" do
      is_expected.to have_css('a', text: other_user.name)
    end
  end

  context "投稿を検索する場合" do
    before {
      select "投稿", from: "model"
      fill_in "keyword", with: micropost.content
      find("#search-btn").click
    }

    example "投稿一覧が表示される" do
      is_expected.to have_css('p', text: micropost.content)
    end
  end
end
