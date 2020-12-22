require 'rails_helper'

RSpec.describe "Searches", type: :system do
  before {
    @user_search_word = "Search Name"
    @micropost_search_word = "Search content"
  }
  let!(:user) { create(:user) }
  let!(:other_user) { create(:test_user, name: @user_search_word) }
  let!(:micropoost) { create(:micropost, user: user, content: @micropost_search_word) }
  before {
    sign_in(user)
    visit root_path
  }
  subject { page }

  context "ユーザーを検索する場合" do
    before {
      select "ユーザー", from: "model"
      fill_in "keyword", with: @user_search_word
      find("#search-btn").click
    }
    example "キーワードに一致するユーザーが表示される" do
      is_expected.to have_css('a', text: @user_search_word)
    end
  end

  context "投稿を検索する場合" do
    before {
      select "投稿", from: "model"
      fill_in "keyword", with: @micropost_search_word
      find("#search-btn").click
    }
    example "投稿一覧が表示される" do
      is_expected.to have_css('p', text: @micropost_search_word)
    end
  end
end
