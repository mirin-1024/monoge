require 'rails_helper'

RSpec.describe "LoginUsers", type: :system do
  context "不正確な情報でログイン" do
    before do
      @user = create(:user)
      visit login_path
      fill_in "メールアドレス", with: ""
      fill_in "パスワード", with: ""
      click_button "ログイン"
    end
    subject { page }
    example "エラーメッセージを表示" do
      is_expected.to have_selector(".alert-danger")
    end
    context "別のページに遷移した場合" do
      before { visit root_path }
      example "エラーメッセージが消える" do
        is_expected.to_not have_selector(".alert-danger")
      end
    end
  end

  context "ログイン" do
    before do
      @user = create(:user)
      visit login_path
      fill_in "メールアドレス", with: "foobar@example.com"
      fill_in "パスワード", with: "password"
      click_button "ログイン"
    end
    subject { page }
    example "メニューが正確に表示される" do
      is_expected.to_not have_link "ログイン", href: login_path
      is_expected.to have_selector(".dropdown-toggle")
    end
    context "ログアウト" do
      it "ログアウト時にメニューが正確に表示される" do
        click_link 'ユーザー'
        click_link 'ログアウト'
        is_expected.to have_current_path root_path
        is_expected.to have_link 'ログイン', href: login_path
        is_expected.to_not have_selector(".dropdown-toggle")
      end
    end
  end
end
