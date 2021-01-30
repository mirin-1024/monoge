require 'rails_helper'

RSpec.describe 'Lists', type: :system do
  subject { page }

  let(:user) { create(:user) }
  let(:list_item) { create(:list_item, user: user) }

  # describe '楽天APIによる商品検索' do
  #   before do
  #     sign_in(user)
  #     visit_lists_path
  #     # 検索フォームに入力
  #     # 検索ボタンをクリック
  #   end

  #   example '検索結果が表示される' do

  #   end
  # end

  describe 'リスト項目の作成' do
    before do
      sign_in(user)
      visit lists_path
    end

    example 'リストが作成される' do
      expect do
        fill_in 'list_content', with: '内容'
        click_on '追加'
      end.to change(List, :count).by(1)
    end

    example 'リストページに遷移する' do
      fill_in 'list_content', with: '内容'
      click_on '追加'
      is_expected.to have_current_path lists_path
    end
  end

  describe 'リスト項目の削除' do
    before do
      sign_in(user)
      visit lists_path
      fill_in 'list_content', with: '内容'
      click_on '追加'
    end

    example 'リストが削除される' do
      expect do
        find('.delete-link').click
      end.to change(List, :count).by(-1)
    end

    example 'リストページに遷移する' do
      find('.delete-link').click
      is_expected.to have_current_path lists_path
    end
  end
end
