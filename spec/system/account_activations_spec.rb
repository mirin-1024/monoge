require 'rails_helper'

RSpec.describe 'AccountActivations', type: :system do
  subject { page }

  context 'ユーザーが有効化されていない場合' do
    let!(:user) { create(:user, :non_activated) }

    describe '有効化トークンとメールアドレス' do
      context '組み合わせが正しい場合' do
        before { visit edit_account_activation_path(user.activation_token, email: user.email) }

        example 'サクセスメッセージが表示される' do
          is_expected.to have_selector('.alert-success', text: 'アカウントが有効化されました！')
        end

        example 'ログインページに遷移する' do
          is_expected.to have_current_path user_path(user)
        end
      end

      context '組み合わせが不正な場合' do
        context '有効化トークンが不正な場合' do
          before { visit edit_account_activation_path('wrong_token', email: user.email) }

          example 'エラーメッセージが表示される' do
            is_expected.to have_selector('.alert-danger', text: '不正なアカウント有効化リンクです')
          end

          example 'トップページに遷移する' do
            is_expected.to have_current_path root_path
          end
        end

        context 'メールアドレスが不正な場合' do
          before { visit edit_account_activation_path(user.activation_token, email: 'wrongemail@example.com') }

          example 'エラーメッセージが表示される' do
            is_expected.to have_selector('.alert-danger', text: '不正なアカウント有効化リンクです')
          end

          example 'トップページに遷移する' do
            is_expected.to have_current_path root_path
          end
        end
      end
    end
  end

  context 'ユーザーが有効化されている場合' do
    let!(:activated_user) { create(:user, :activated) }

    before { visit edit_account_activation_path(activated_user.activation_token, email: activated_user.email) }

    example 'エラーメッセージが表示される' do
      is_expected.to have_selector('.alert-danger', text: '不正なアカウント有効化リンクです')
    end

    example 'トップページに遷移する' do
      is_expected.to have_current_path root_path
    end
  end
end
