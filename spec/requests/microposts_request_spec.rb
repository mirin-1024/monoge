require 'rails_helper'

RSpec.describe "Microposts", type: :request do
  let!(:user) { create(:user) }
  let(:other_user) { create(:other_user) }
  subject { response }

  describe "投稿の作成" do
    let(:create_request) { post microposts_path, params: { micropost: attributes_for(:micropost, user: user) } }
    context "ログインしている場合" do
      before { log_in_as(user) }
      example "投稿が作成される" do
        expect { create_request }.to change(Micropost, :count).by(1)
      end
    end
    context "ログインしていない場合" do
      example "投稿が作成されない" do
        expect { create_request }.to change(Micropost, :count).by(0)
      end
      example "ログインページへリダイレクト" do
        create_request
        is_expected.to redirect_to login_url
      end
    end
  end

  describe "投稿の削除" do
    let!(:user_micropost) { create(:test_micropost, user: user) }
    let(:delete_request) { delete micropost_path(user_micropost) }

    context "ログインしている場合" do
      before { log_in_as(user) }
      context "適切なユーザーが削除する場合" do
        example "投稿が削除される" do
          expect { delete_request }.to change(Micropost, :count).by(-1)
        end
        example "トップページへリダイレクト" do
          # redirect_backのより正確なテスト
          delete_request
          is_expected.to redirect_to root_url
        end
      end
      context "不正なユーザーが削除する場合" do
        before {
          log_in_as(other_user)
        }
        example "投稿が削除されない" do
          expect { delete_request }.to change(Micropost, :count).by(0)
        end
      end
    end
    context "ログインしていない場合" do
      example "投稿が削除されない" do
        expect { delete_request }.to change(Micropost, :count).by(0)
      end
      example "ログインページへリダイレクト" do
        delete_request
        is_expected.to redirect_to login_url
      end
    end
  end
end
