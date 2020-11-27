require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "before_action :logged_in_user" do
    let(:user) { create(:user) }
    let(:other_user) { create(:other_user) }
    describe "GET #edit"  do
      context "未ログインの時" do
        before {
          get edit_user_path(user)
        }
        subject { response }
        example "エラーメッセージを表示" do
          expect(flash[:danger]).to_not be_empty
        end
        example "ログインページへリダイレクト" do
          is_expected.to redirect_to login_url
          is_expected.to have_http_status(302)
        end
        # sessionsヘルパーテストへ移動
        context "ログイン後" do
          before { log_in_as(user) }
          example "フレンドリーフォワーディングされる" do
            is_expected.to redirect_to edit_user_url(user)
          end
        end
      end
      context "異なるユーザーでログインした時" do
        before {
          log_in_as(other_user)
          get edit_user_path(user)
        }
        subject { response }
        example "エラーメッセージを表示" do
          expect(flash[:danger]).to be_nil
        end
        example "トップページへリダイレクト" do
          is_expected.to redirect_to root_url
          is_expected.to have_http_status(302)
        end
      end
    end
    describe "PATCH #update" do
      context "未ログインの時" do
        before {
          patch user_path(user), params: { user: { name: user.name,
                                                  email: user.email } }
        }
        subject { response }
        example "エラーメッセージを表示" do
          expect(flash[:danger]).to_not be_empty
        end
        example "ログインページへリダイレクト" do
          is_expected.to redirect_to login_url
          is_expected.to have_http_status(302)
        end
      end
      context "異なるユーザーでログインした時" do
        before {
          log_in_as(other_user)
          patch user_path(user), params: { user: { name: user.name,
                                                  email: user.email } }
        }
        subject { response }
        example "エラーメッセージを表示" do
          expect(flash[:danger]).to be_nil
        end
        example "ログインページへリダイレクト" do
          is_expected.to redirect_to root_url
          is_expected.to have_http_status(302)
        end
      end
    end
    describe "GET #index" do
      context "未ログインの時" do
        before { get users_path }
        subject { response }
        example "ログインページへリダイレクト" do
          is_expected.to redirect_to login_url
          is_expected.to have_http_status(302)
        end
      end
    end
    describe "DELETE #destroy" do
      context "未ログインの時" do
        subject { response }
        example "ログインページへリダイレクト" do
          delete user_path(user)
          is_expected.to redirect_to login_url
          is_expected.to have_http_status(302)
        end
      end
    end
  end
  describe "before_action :correct_user" do
    
  end
  describe "before_action :admin_user" do
    let!(:user) { create(:user) }
    let!(:other_user) { create(:other_user) }
    let!(:admin_user) { create(:test_user, :admin) }
    describe "DELETE #destroy" do
      example "管理者ユーザーでない場合に失敗する" do
        log_in_as(user)
        expect do
          delete user_path(other_user)
        end.to change(User, :count).by(0)
      end
      example "管理者ユーザーである場合に成功する" do
        log_in_as(admin_user)
        expect do
          delete user_path(user)
        end.to change(User, :count).by(-1)
        expect(response).to redirect_to users_url
      end
    end
  end
end
