require 'rails_helper'

RSpec.describe "PasswordResets", type: :request do
  let!(:user) { create(:user, :activated) }

  before { user.create_reset_digest }

  describe "GET #edit" do
    before { get new_password_reset_path }

    context "送信されたメールアドレスがデータベースに存在する" do
      before {
        post password_resets_path, params: { password_reset: { email: user.email } }
      }

      example "再設定用のダイジェストが更新されている" do
        expect(user.reset_digest).to_not eq user.reload.reset_digest
      end
    end

    context "送信されたメールアドレスがデータベースに存在しない" do
      before {
        post password_resets_path, params: { password_reset: { email: "" } }
      }

      example "再設定用のダイジェストが更新されていない" do
        expect(user.reset_digest).to eq user.reload.reset_digest
      end
    end
  end

  describe "PATCH #update" do
    context "適切なパスワードを送信した場合" do
      before {
        patch password_reset_path(user.reset_token, params: { email: user.email,
                                                              user: { password: user.password,
                                                                      password_confirmation: user.password } } )
      }

      example "再設定ダイジェストがnilである" do
        expect(user.reload.reset_digest).to eq nil
      end
    end

    context "不正なパスワードを送信した場合" do
      before {
        patch password_reset_path(user.reset_token, params: { email: user.email,
                                                              user: { password: 'newpassword',
                                                                      password_confirmation: 'newpassward' } } )
      }

      example "再設定ダイジェストがnilである" do
        expect(user.reload.reset_digest).to_not eq nil
      end
    end
  end
end
