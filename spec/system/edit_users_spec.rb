require 'rails_helper'

RSpec.describe "ユーザー情報の編集", type: :system do
  let(:user) { create(:user) }
  context "編集成功時" do
    before do
      log_in(user)
      visit edit_user_path(user)
      fill_in "名前", with: "FooFoo"
      fill_in "メールアドレス", with: "foofoo@example.com"
      fill_in "パスワード", with: "password"
      fill_in "パスワード（確認）", with: "password"
      click_button "変更"
    end
    subject { page }
    example "フラッシュメッセージが表示される" do
      is_expected.to have_selector('.alert-success')
    end
    example "ユーザーページにリダイレクト" do
      expect(current_path).to eq user_path(user)
    end
  end

  context "編集失敗時" do
    before do
      log_in(user)
      visit edit_user_path(user)
      fill_in "名前", with: ""
      fill_in "メールアドレス", with: ""
      fill_in "パスワード", with: ""
      fill_in "パスワード（確認）", with: ""
      click_button "変更"
    end
    subject { page }
    example "正しくレンダリングされる" do
      is_expected.to have_content 'ユーザー情報の編集'
    end
    example "エラーメッセージが表示される" do
      is_expected.to have_selector('.alert-danger')
    end
  end
end
