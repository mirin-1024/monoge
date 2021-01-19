require 'rails_helper'

RSpec.describe 'Microposts', type: :system do
  include CarrierWave::Test::Matchers

  subject { page }

  let!(:user) { create(:user) }
  let(:micropost_count) { 0 }

  describe '投稿の作成' do
    before do
      sign_in(user)
      visit root_path
    end

    context '投稿が適切な場合' do
      let(:create_valid_micropost) do
        fill_in 'micropost_content', with: '適切な投稿'
        click_button '投稿'
      end

      example '投稿一覧の投稿が増える' do
        create_valid_micropost
        is_expected.to have_css('span.content', text: '適切な投稿')
      end

      example '投稿数の表示が増える' do
        create_valid_micropost
        is_expected.to have_css('.post_count', text: "#{micropost_count + 1} 投稿")
      end

      example 'サクセスメッセージを表示' do
        create_valid_micropost
        is_expected.to have_selector('.alert-success', text: '投稿を作成しました')
      end

      example 'トップページに遷移する' do
        create_valid_micropost
        is_expected.to have_current_path root_path
      end
    end

    context '投稿が不正な場合' do
      let(:create_invalid_micropost) do
        fill_in 'micropost_content', with: ''
        click_button '投稿'
      end

      example '投稿一覧が変化しない' do
        create_invalid_micropost
        is_expected.to_not have_css('span.content', text: '')
      end

      example '投稿数の表示が変化しない' do
        create_invalid_micropost
        is_expected.to have_css('.post_count', text: "#{micropost_count} 投稿")
      end

      example 'トップページを描画' do
        create_invalid_micropost
        is_expected.to have_css('#micropost_form')
      end
    end

    describe '画像の投稿' do
      let(:image_name) { 'neko.jpg' }

      before do
        # ボタンをクリックでアップロードする際のテスト
        attach_file 'micropost_image', "#{Rails.root}/spec/fixtures/#{image_name}", make_visible: true
        fill_in 'micropost_content', with: '適切な投稿'
        click_button '投稿'
      end

      example '画像が投稿一覧に表示される' do
        is_expected.to have_selector "img[src$='#{image_name}']"
      end
      # リサイズのテスト
    end
  end

  describe '投稿の削除' do
    before do
      sign_in(user)
      visit root_path
      fill_in 'micropost_content', with: '適切な投稿'
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
