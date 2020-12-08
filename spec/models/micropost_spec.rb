require 'rails_helper'

RSpec.describe Micropost, type: :model do
  let(:micropost) { create(:micropost) }

  context "適切な投稿を作成した場合" do
    example "投稿が適切である" do
      expect(micropost).to be_valid
    end
  end
  context "不適切な投稿を作成した場合" do
    context "ユーザーIDが不適切な場合" do
      example "ユーザーIDが存在していなければならない" do
        expect(build(:micropost, user_id: nil)).to_not be_valid
      end
    end
    context "内容が不適切な場合" do
      example "内容が存在している" do
        expect(build(:micropost, content: "")).to_not be_valid
      end
      example "内容が最大140文字である" do
        expect(build(:micropost, content: "a" * 141)).to_not be_valid
      end
    end
  end
  describe "投稿の順序" do
    let!(:user) { create(:user) }
    let!(:day_before_yesterday) { create(:micropost, :day_before_yesterday, user: user) }
    let!(:yesterday) { create(:micropost, :yesterday, user: user) }
    let!(:now) { create(:micropost, :now, user: user) }
    example "最新の投稿が最初に表示される" do
      expect(Micropost.first).to eq now
    end
  end
end
