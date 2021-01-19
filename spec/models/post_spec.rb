require 'rails_helper'

RSpec.describe Post, type: :model do
  let(:post) { create(:post) }

  context '適切な投稿を作成した場合' do
    example '投稿が適切である' do
      expect(post).to be_valid
    end
  end

  context '不適切な投稿を作成した場合' do
    context 'ユーザーIDが不適切な場合' do
      example 'ユーザーIDが存在していなければならない' do
        expect(build(:post, user_id: nil)).to_not be_valid
      end
    end

    context '内容が不適切な場合' do
      example '内容が存在している' do
        expect(build(:post, content: '')).to_not be_valid
      end

      example '内容が最大140文字である' do
        expect(build(:post, content: 'a' * 141)).to_not be_valid
      end
    end
  end

  describe '投稿の順序' do
    let!(:user) { create(:user) }
    let!(:now) { create(:post, :now, user: user) }

    before do
      create(:post, :day_before_yesterday, user: user)
      create(:post, :yesterday, user: user)
    end

    example '最新の投稿が最初の順番にソートされる' do
      expect(Post.first).to eq now
    end
  end
end
