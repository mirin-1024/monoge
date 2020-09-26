require 'rails_helper'

RSpec.describe "SignupUsers", type: :system do
  describe "Sign up with valid information" do
    before do
    visit signup_path
      fill_in "名前", with: "Foobar"
      fill_in "メールアドレス", with: "foobar@example.com"
      fill_in "パスワード", with: "password"
      fill_in "パスワード（確認）", with: "password"
      click_button "登録"
    end
    subject { page }
    it "has success message" do
      is_expected.to have_selector(".alert-success")
    end
  end

  describe "Sign up with invalid information" do
    before do
      visit signup_path
      fill_in "名前", with: ""
      fill_in "メールアドレス", with: ""
      fill_in "パスワード", with: ""
      fill_in "パスワード（確認）", with: ""
      click_button "登録"
    end
    subject { page }
    it "has error message" do
      is_expected.to have_selector(".alert-danger")
    end
  end
end
