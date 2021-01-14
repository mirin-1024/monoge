require 'rails_helper'

RSpec.describe 'Sessions', type: :request do
  subject { response }

  let!(:user) { create(:user, :activated) }
  let(:other_user) { create(:other_user) }

  before 'ユーザーID、メールアドレス、パスワード、remember_meをセッションから取り出せるようにする' do
    allow_any_instance_of(ActionDispatch::Request).to receive(:session).and_return(user_id: user.id,
                                                                                   email: user.email,
                                                                                   password: user.password,
                                                                                   remember_me: '1',
                                                                                   forwarding_url: nil)
  end

  # describe 'GET #new' do
  #   before { get login_path }

  #   example '200レスポンスを返す' do
  #     is_expected.to have_http_status(:ok)
  #   end
  # end

  describe 'POST #create' do
    context '正確なパラメータでログインする場合' do
      example 'ユーザーが存在している' do
        log_in_as(user)
        expect(user).to be_valid
      end

      example 'ユーザーが認証されている' do
        log_in_as(user)
        expect(user.authenticate(session[:password])).to be_truthy
      end

      context 'ユーザーが有効化されている場合' do
        example 'セッションにIDが保存されている' do
          log_in_as(user)
          expect(session[:user_id]).to eq user.id
        end

        describe 'Remember me' do
          example 'チェックボックスがONのとき' do
            log_in_as(user, remember_me: '1')
            expect(cookies[:remember_token]).to_not be_empty
          end

          example 'チェックボックスがOFFの時' do
            log_in_as(user, remember_me: '0')
            expect(cookies[:remember_token]).to be_nil
          end
        end

        describe 'リダイレクト先' do
          context 'ログイン前に保護されたページにアクセスした場合' do
            before { allow_any_instance_of(ActionDispatch::Request).to receive(:session).and_return(forwarding_url: edit_user_path(user)) }

            example 'ユーザーフレンドリーなURLにリダイレクト' do
              log_in_as(user)
              is_expected.to redirect_to edit_user_url(user)
            end
          end

          context 'ログイン前に保護されたページにアクセスしていない場合' do
            before { allow_any_instance_of(ActionDispatch::Request).to receive(:session).and_return(forwarding_url: nil) }

            example 'ユーザーページへリダイレクト' do
              log_in_as(user)
              is_expected.to redirect_to user_url(user)
            end
          end
        end
      end

      # context 'ユーザーが有効化されていない場合' do
      #   let!(:non_activated_user) { create(:test_user, :non_activated) }

      #   example '302レスポンスを返す' do
      #     log_in_as(non_activated_user)
      #     is_expected.to have_http_status(:found)
      #   end
      # end
    end

    # context 'パラメータが不正な場合' do
    #   before { post login_path, params: { session: attributes_for(:other_user) } }

    #   example '200レスポンスを返す' do
    #     is_expected.to have_http_status(:ok)
    #   end
    # end
  end

  describe 'DELETE #destroy' do
    context 'ログインしている場合' do
      before { log_in_as(user) }

      example 'ログアウトする' do
        delete logout_path
        expect(session[:user_id]).to eq nil
      end

      # example '302レスポンスを返す' do
      #   delete logout_path
      #   is_expected.to have_http_status(:found)
      # end
    end

    # context 'ログインしていない場合' do
    #   example '302レスポンスを返す' do
    #     delete logout_path
    #     is_expected.to have_http_status(:found)
    #   end
    # end
  end
end
