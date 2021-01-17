require 'rails_helper'

RSpec.describe 'UsersSession', type: :system do
  subject { page }

  let!(:user) { create(:user) }

  describe 'ユーザーのログイン' do
    before { visit login_path }

    context '正しい情報を入力した場合' do
      context 'アカウントが有効化されている場合' do
        before { sign_in(user) }

        describe 'ログインユーザー専用のヘッダーメニューを表示' do
          example '「ユーザー」項目が表示される' do
            is_expected.to have_selector('a.dropdown-toggle', text: 'ユーザー')
          end

          example '「ログイン」項目が表示される' do
            is_expected.to_not have_link 'ログイン', href: login_path
          end
        end

        example 'ユーザーページに遷移する' do
          is_expected.to have_current_path user_path(user)
        end
      end

      context 'アカウントが有効化されていない場合' do
        let!(:non_activated_user) { create(:test_user, :non_activated) }

        before { sign_in(non_activated_user) }

        example 'エラーメッセージを表示' do
          is_expected.to have_selector('.alert-warning', text: 'アカウントが有効化されていません。メールを確認してください。')
        end

        example 'トップページに遷移する' do
          is_expected.to have_current_path root_path
        end
      end
    end

    context '不正な情報を入力した場合' do
      before do
        fill_in 'メールアドレス', with: ''
        fill_in 'パスワード', with: ''
        click_button 'ログイン'
      end

      example 'エラーメッセージを表示' do
        is_expected.to have_selector('.alert-danger')
      end

      describe '未ログインユーザー専用のヘッダーメニューを表示' do
        example '「ユーザー」項目が表示されない' do
          is_expected.to_not have_selector('a.dropdown-toggle', text: 'ユーザー')
        end

        example '「ログイン」項目が表示される' do
          is_expected.to have_link 'ログイン', href: login_path
        end
      end

      example 'ログインページが描画される' do
        is_expected.to have_selector('h1', text: 'ログイン')
      end
    end
  end

  describe 'ゲストユーザーのログイン' do
    let!(:guest_user) { create(:guest_user) }

    before do
      visit root_path
      click_on 'ゲストログイン'
    end

    example 'トップページに遷移' do
      is_expected.to have_current_path root_path
    end

    example '名前が正しく表示されている' do
      is_expected.to have_selector('h1', text: guest_user.name)
    end
  end

  describe 'ユーザーのログアウト' do
    before do
      sign_in(user)
      find('a.dropdown-toggle', text: 'ユーザー').click
      click_link 'ログアウト'
    end

    describe '未ログインユーザーのヘッダーメニューを表示' do
      example '「ユーザー」項目が表示される' do
        is_expected.to_not have_selector('a.dropdown-toggle', text: 'ユーザー')
      end

      example '「ログイン」項目が表示される' do
        is_expected.to have_link 'ログイン', href: login_path
      end
    end

    example 'トップページに遷移する' do
      is_expected.to have_current_path root_path
    end
  end
end
