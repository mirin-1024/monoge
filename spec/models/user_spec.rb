require 'rails_helper'

RSpec.describe User, type: :model do

  let (:user) { build(:user) }
  context "正確なユーザーを作成" do
    example "ユーザーが正確である" do
      expect(user).to be_valid
    end
    example "記憶ダイジェストがないユーザーがエラーを返す" do
      expect(user.authenticated?('')).to be_falsey
    end
  end

  context "不正確なユーザーを作成" do
    let (:invuser) { build(:invuser) }
    example "不正確なユーザーをはじく" do
      expect(invuser).not_to be_valid
    end
  end

end
