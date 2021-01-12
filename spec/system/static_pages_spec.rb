require 'rails_helper'

RSpec.describe "StaticPages", type: :system do
  subject { page }

  describe "トップページ" do
    let!(:user) { create(:user) }

    before {
      @post_count = 50
      @post_count.times { create(:test_micropost, user: user) }
    }

    context "ログインしている場合" do
      before {
        sign_in(user)
        visit root_path
      }

      describe "ユーザー情報" do
        example "ユーザー情報が表示されている" do
          is_expected.to have_content "#{@post_count} 投稿"
        end
      end

      describe "投稿作成フォーム" do
        example "投稿作成フォームが表示されている" do
          is_expected.to have_css "input.btn"
        end
      end

      describe "ステータスフィード" do
        example "ページネーションが表示されている" do
          is_expected.to have_css "ul.pagination"
        end
      end
    end

    context "ログインしていない場合" do
      before { visit root_path }

      example "未ログイン時のトップページが表示されている" do
        is_expected.to have_css("a.btn", text: "ユーザー登録")
      end
    end
  end
end
