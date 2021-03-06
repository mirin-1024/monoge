require 'rails_helper'

RSpec.describe 'PostComments', type: :system do
  subject { page }

  let!(:user) { create(:user) }
  let!(:other_user) { create(:test_user) }
  let!(:user_post) { create(:post, user: user) }
  let!(:comment_content) { 'コメント内容' }

  before do
    sign_in(other_user)
    visit post_path(user_post)
  end

  describe 'コメントの投稿' do
    example 'コメントがデータベースに保存される' do
      expect do
        find('textarea').set(comment_content)
        click_on 'コメントする'
      end.to change(Comment, :count).by(1)
    end

    example 'コメントが表示される' do
      find('textarea').set(comment_content)
      click_on 'コメントする'
      is_expected.to have_content comment_content
    end
  end

  describe 'コメントの削除' do
    before do
      find('textarea').set(comment_content)
      click_on 'コメントする'
    end

    example 'コメントがデータベースから削除される' do
      expect do
        click_on '削除'
      end.to change(Comment, :count).by(-1)
    end

    example 'コメントが削除される' do
      click_on '削除'
      is_expected.to_not have_content comment_content
    end
  end
end
