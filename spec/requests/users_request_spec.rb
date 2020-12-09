require 'rails_helper'

RSpec.describe "Users", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:other_user) }
  let!(:admin_user) { create(:admin_user) }
  subject { response }

  describe "GET #new" do
    before { get signup_path }
    example "200レスポンスを返す" do
      is_expected.to have_http_status(200)
    end
  end

  describe "GET #show" do
    before { get user_path(user) }
    example "200レスポンスを返す" do
      is_expected.to have_http_status(200)
    end
  end

  describe "POST #create" do
    context "パラメータが妥当な場合" do
      example "データベースにユーザーが保存される" do
        expect do
          post users_path, params: { user: attributes_for(:user) }
        end.to change(User, :count).by(1)
      end
      example "配信されるメールは一通である" do
        post users_path, params: { user: attributes_for(:user) }
        expect(ActionMailer::Base.deliveries.size).to eq(1)
      end
      example "302レスポンスを返す" do
        post users_path, params: { user: attributes_for(:user) }
        is_expected.to have_http_status(302)
      end
    end
    context "パラメータが不正な場合" do
      example "データベースにユーザーが保存されない" do
        expect do
          post users_path, params: { user: attributes_for(:invalid_user) }
        end.to_not change(User, :count)
      end
      example "200レスポンスを返す" do
        post users_path, params: { user: attributes_for(:invalid_user) }
        is_expected.to have_http_status(200)
      end
    end
  end

  describe "GET #edit" do
    context "正常にログインした場合" do
      before {
        log_in_as(user)
        get edit_user_path(user)
      }
      example "200レスポンスを返す" do
        is_expected.to have_http_status(200)
      end
    end
    context "ログインしていない場合" do
      before { get edit_user_path(user) }
      example "302レスポンスを返す" do
        is_expected.to have_http_status(302)
      end
    end
    context "異なるユーザーでログインした場合" do
      before {
        log_in_as(other_user)
        get edit_user_path(user)
      }
      example "302レスポンスを返す" do
        is_expected.to have_http_status(302)
      end
    end
  end

  describe "PATCH #update" do
    context "正常にログインした場合" do
      before {
        log_in_as(user)
        patch user_path(user), params: { user: attributes_for(:user) }
      }
      example "302レスポンスを返す" do
        is_expected.to have_http_status(302)
      end
    end
    context "ログインしていない場合" do
      before {
        patch user_path(user), params: { user: attributes_for(:user) }
      }
      example "302レスポンスを返す" do
        is_expected.to have_http_status(302)
      end
    end
    context "異なるユーザーでログインした場合" do
      before {
        log_in_as(other_user)
        patch user_path(user), params: { user: attributes_for(:user) }
      }
      example "302レスポンスを返す" do
        is_expected.to have_http_status(302)
      end
    end
  end

  describe "GET #index" do
    context "ログインしている場合" do
      before {
        log_in_as(user)
        get users_path
      }
      example "200レスポンスを返す" do
        is_expected.to have_http_status(200)
      end
    end
    context "ログインしていない場合" do
      before { get users_path }
      example "302レスポンスを返す" do
        is_expected.to have_http_status(302)
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:user) { create(:user) }
    let(:admin_user) { create(:admin_user) }

    context "ログインしている場合" do
      context "管理者ユーザーであるとき" do
        before { log_in_as(admin_user) }
        example "データベースからユーザーが削除される" do
          expect do
            delete user_path(user)
          end.to change(User, :count).by(-1)
        end
        example "302レスポンスを返す" do
          delete user_path(user)
          is_expected.to have_http_status(302)
        end
      end
      context "通常のユーザーであるとき" do
        before {
          log_in_as(other_user)
        }
        example "データベースからユーザーが削除されない" do
          expect do
            delete user_path(user)
          end.to_not change(User, :count)
        end
        example "302レスポンスを返す" do
          delete user_path(user)
          is_expected.to have_http_status(302)
        end
      end
    end
    context "ログインしていない場合" do
      before { delete user_path(user) }
      example "302レスポンスを返す" do
        is_expected.to have_http_status(302)
      end
    end
  end
end
