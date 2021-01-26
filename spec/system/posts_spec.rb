require 'rails_helper'

RSpec.describe 'Posts', type: :system do
  include CarrierWave::Test::Matchers

  subject { page }

  let!(:user) { create(:user) }
  let(:post) { create(:post, user: user) }
  let(:post_count) { 0 }

  describe '投稿の作成' do
    before do
      sign_in(user)
      visit root_path
    end

    context '投稿が適切な場合' do
      let(:create_valid_post) do
        fill_in 'post_content', with: '適切な投稿'
        click_button '投稿'
      end

      example '投稿一覧の投稿が増える' do
        create_valid_post
        is_expected.to have_css('.post-content', text: '適切な投稿')
      end

      example '投稿数の表示が増える' do
        create_valid_post
        is_expected.to have_css('.post-count', text: "#{post_count + 1} 投稿")
      end

      example 'サクセスメッセージを表示' do
        create_valid_post
        is_expected.to have_selector('.alert-success', text: '投稿を作成しました')
      end

      example 'トップページに遷移する' do
        create_valid_post
        is_expected.to have_current_path root_path
      end
    end

    context '投稿が不正な場合' do
      let(:create_invalid_post) do
        fill_in 'post_content', with: ''
        click_button '投稿'
      end

      example '投稿一覧が変化しない' do
        create_invalid_post
        is_expected.to_not have_css('.post-content', text: '')
      end

      example '投稿数の表示が変化しない' do
        create_invalid_post
        is_expected.to have_css('.post-count', text: "#{post_count} 投稿")
      end

      example 'トップページを描画' do
        create_invalid_post
        is_expected.to have_css('.post-form')
      end
    end

    describe '画像の投稿' do
      let(:image_path) { Rails.root.join('spec/fixtures/neko.jpg').to_s }

      before do
        fill_in 'post_content', with: '画像テスト'
        attach_file 'post_image', image_path
        click_button '投稿'
      end

      example '画像が投稿一覧に表示される' do
        is_expected.to have_css '.user-image img'
      end
      example '画像のモーダルが表示される' do
        find('.post-image img').click
        is_expected.to have_css '.modal'
      end
    end
  end

  describe '投稿の削除' do
    before do
      sign_in(user)
      visit root_path
      fill_in 'post_content', with: '適切な投稿'
      click_button '投稿'
    end

    example '投稿が削除される' do
      click_link '削除', match: :first
      is_expected.to_not have_css('span.content', text: '適切な投稿')
    end

    example 'サクセスメッセージを表示' do
      click_link '削除', match: :first
      is_expected.to have_selector('.alert-success', text: '投稿が削除されました')
    end

    example 'トップページに遷移する' do
      # redirect_backのより正確なテスト
      click_link '削除', match: :first
      is_expected.to have_current_path root_path
    end
  end
end
