require 'rails_helper'

RSpec.describe "UsersSession", type: :system do
  let!(:user) { create(:user) }
  subject { page }

  # sessions #createの検証
  describe "ユーザーのログイン" do
    before { visit login_path }
    context "正しい情報を入力した場合" do
      before { sign_in(user) }
      example "ログインユーザー専用のヘッダーメニューが表示される" do
        is_expected.to have_selector('a.dropdown-toggle', text: 'ユーザー')
        is_expected.to_not have_link "ログイン", href: login_path
      end
      example "ユーザーページに遷移する" do
        is_expected.to have_current_path user_path(user)
      end
    end
    context "不正な情報を入力した場合" do
      before {
        fill_in "メールアドレス", with: ""
        fill_in "パスワード", with: ""
        click_button "ログイン"
      }
      example "エラーメッセージを表示" do
        is_expected.to have_selector(".alert-danger")
      end
      example "未ログインユーザー専用のヘッダーメニューが表示される" do
        is_expected.to_not have_selector('a.dropdown-toggle', text: 'ユーザー')
        is_expected.to have_link "ログイン", href: login_path
      end
      example "ログインページが描画される" do
        is_expected.to have_selector('h1', text: 'ログイン')
      end
    end
  end
# sessions #destroyの検証
  describe "ユーザーのログアウト" do
    before {
      sign_in(user)
      find('a.dropdown-toggle', text: 'ユーザー').click
      click_link "ログアウト"
    }
    example "未ログインユーザー専用のヘッダーメニューが表示される" do
      is_expected.to_not have_selector('a.dropdown-toggle', text: 'ユーザー')
      is_expected.to have_link "ログイン", href: login_path
    end
    example "トップページに遷移する" do
      is_expected.to have_current_path root_path
    end
  end
end
