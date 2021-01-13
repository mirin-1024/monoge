require 'rails_helper'

RSpec.describe "PasswordResets", type: :system do
  subject { page }

  let!(:user) { create(:user, :activated) }

  before { user.create_reset_digest }

  describe "パスワード変更ページ" do
    before { visit new_password_reset_path }

    context "送信されたメールアドレスがデータベースに存在する" do
      before do
        fill_in 'メールアドレス', with: user.email
        click_button '送信'
      end

      example "完了メッセージが表示される" do
        is_expected.to have_selector('.alert-info', text: 'パスワード再設定用のメールを送信しました')
      end

      example "トップページに遷移する" do
        is_expected.to have_current_path root_path
      end
    end

    context "送信されたメールアドレスがデータベースに存在しない" do
      before do
        fill_in 'メールアドレス', with: 'wrongemail@example.com'
        click_button '送信'
      end

      example "エラーメッセージが表示される" do
        is_expected.to have_selector('.alert-danger', text: 'メールアドレスが登録されていません')
      end

      example "パスワード変更ページが描画される" do
        is_expected.to have_selector('h1', text: 'パスワードの変更')
      end
    end
  end

  describe "パスワード再設定ページ" do
    context "適切なユーザーがアクセスした場合" do
      context "パスワードが空白である場合" do
        before do
          visit edit_password_reset_url(user.reset_token, email: user.email)
          fill_in "パスワード", with: ""
          fill_in "パスワード（確認）", with: ""
          click_button 'パスワードを変更'
        end

        example "エラーメッセージが表示される" do
          is_expected.to have_selector('.alert-danger')
        end
      end

      context "パスワードが空白でない場合" do
        context "パスワードが適切な場合" do
          before do
            visit edit_password_reset_url(user.reset_token, email: user.email)
            fill_in "パスワード", with: "newpassword"
            fill_in "パスワード（確認）", with: "newpassword"
            click_button 'パスワードを変更'
          end

          example "パスワードが更新される" do
            expect(user.password_digest).to_not eq user.reload.password_digest
          end

          example "サクセスメッセージが表示される" do
            is_expected.to have_selector('.alert-success', text: 'パスワードが再設定されました')
          end

          example "ユーザーページに遷移する" do
            is_expected.to have_current_path user_path(user)
          end
        end

        context "パスワードが不正な場合" do
          before do
            visit edit_password_reset_url(user.reset_token, email: user.email)
            fill_in "パスワード", with: "newpassword"
            fill_in "パスワード（確認）", with: "newpassward"
            click_button 'パスワードを変更'
          end

          example "パスワードが更新されない" do
            expect(user.password_digest).to eq user.reload.password_digest
          end

          example "パスワード再設定ページを描画" do
            is_expected.to have_selector('h1', text: 'パスワードの再設定')
          end
        end
      end
    end

    context "適切でないユーザーがアクセスした場合" do
      context "有効化されていないユーザーがアクセスした場合" do
        let!(:non_activated_user) { create(:test_user, :non_activated) }

        before do
          non_activated_user.create_reset_digest
          visit edit_password_reset_url(non_activated_user.reset_token, email: non_activated_user.email)
        end

        example "トップページに遷移する" do
          is_expected.to have_current_path root_path
        end
      end

      context "メールアドレスが不正な場合" do
        before { visit edit_password_reset_url(user.reset_token, email: 'wrongemail@example.com') }

        example "トップページに遷移する" do
          is_expected.to have_current_path root_path
        end
      end

      context "再設定トークンが不正な場合" do
        before { visit edit_password_reset_url('wrongtoken', email: user.email) }

        example "トップページに遷移する" do
          is_expected.to have_current_path root_path
        end
      end

      context "パスワード再設定期限を過ぎている場合" do
        before do
          user.update_attribute(:reset_sent_at, 3.hours.ago)
          visit edit_password_reset_url(user.reset_token, email: user.email)
        end

        example "エラーメッセージが表示される" do
          is_expected.to have_selector('.alert-danger', text: 'パスワード再設定期限が終了しました')
        end

        example "トップページに遷移する" do
          is_expected.to have_current_path new_password_reset_path
        end
      end
    end
  end
end
