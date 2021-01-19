require 'rails_helper'

RSpec.describe 'Posts', type: :request do
  subject { response }

  let!(:user) { create(:user) }
  let(:other_user) { create(:test_user) }

  describe '投稿の作成' do
    let(:create_request) { post posts_path, params: { post: attributes_for(:post, user: user) } }

    context 'ログインしている場合' do
      before { log_in_as(user) }

      example '投稿が作成される' do
        expect { create_request }.to change(Post, :count).by(1)
      end
    end

    context 'ログインしていない場合' do
      example '投稿が作成されない' do
        expect { create_request }.to change(Post, :count).by(0)
      end

      example 'ログインページへリダイレクト' do
        create_request
        is_expected.to redirect_to login_url
      end
    end
  end

  describe '投稿の削除' do
    let!(:user_post) { create(:test_post, user: user) }
    let(:delete_request) { delete post_path(user_post) }

    context 'ログインしている場合' do
      before { log_in_as(user) }

      context '適切なユーザーが削除する場合' do
        example '投稿が削除される' do
          expect { delete_request }.to change(Post, :count).by(-1)
        end

        example 'トップページへリダイレクト' do
          # redirect_backのより正確なテスト
          delete_request
          is_expected.to redirect_to root_url
        end
      end

      context '不正なユーザーが削除する場合' do
        before { log_in_as(other_user) }

        example '投稿が削除されない' do
          expect { delete_request }.to change(Post, :count).by(0)
        end
      end
    end

    context 'ログインしていない場合' do
      example '投稿が削除されない' do
        expect { delete_request }.to change(Post, :count).by(0)
      end

      example 'ログインページへリダイレクト' do
        delete_request
        is_expected.to redirect_to login_url
      end
    end
  end
end
