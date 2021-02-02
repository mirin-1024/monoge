require 'rails_helper'

RSpec.describe 'Lists', type: :system do
  subject { page }

  let(:user) { create(:user) }
  let(:list_item) { create(:list_item, user: user) }

  describe 'リスト項目の作成' do
    before do
      sign_in(user)
      visit lists_path
    end

    example 'リストが作成される' do
      expect do
        fill_in 'list_content', with: '内容'
        find('.submit-btn').click
      end.to change(List, :count).by(1)
    end

    example 'リストページに遷移する' do
      fill_in 'list_content', with: '内容'
      find('.submit-btn').click
      is_expected.to have_current_path lists_path
    end
  end

  describe 'リスト項目の編集' do
    before do
      sign_in(user)
      visit lists_path
      fill_in 'list_content', with: '内容'
      find('.submit-btn').click
      page.first('.edit-btn').click
    end

    example '編集用モーダルが表示される' do
      is_expected.to have_css('.modal')
    end

    example '正常に編集できる' do
      find('.modal-content-form').set('内容2')
      find('.modal-submit-btn').click
      is_expected.to have_content '内容2'
    end
  end

  describe 'リスト項目の削除' do
    before do
      sign_in(user)
      visit lists_path
      fill_in 'list_content', with: '内容'
      find('.submit-btn').click
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
