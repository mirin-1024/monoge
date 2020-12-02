require 'rails_helper'

RSpec.describe "Users", type: :system do
  subject { page }

  describe "ユーザーの登録" do
    before { visit signup_path }

    context "正確な情報を入力した場合" do
      before do
        fill_in "名前", with: "Foobar"
        fill_in "メールアドレス", with: "foobar@example.com"
        fill_in "パスワード", with: "password"
        fill_in "パスワード（確認）", with: "password"
      end
      example "サクセスメッセージが表示される" do
        click_button "登録"
        is_expected.to have_selector('.alert-success', text: 'monogeへようこそ！')
      end
      example "ユーザーページに遷移する" do
        click_button "登録"
        is_expected.to have_current_path user_path(User.last)
      end
    end
    context "不正な情報を入力した場合" do
      before do
        visit signup_path
        fill_in "名前", with: ""
        fill_in "メールアドレス", with: ""
        fill_in "パスワード", with: ""
        fill_in "パスワード（確認）", with: ""
      end
      example "エラーメッセージが表示される" do
        click_button "登録"
        is_expected.to have_selector(".alert-danger")
      end
      example "ユーザー登録ページが描画される" do
        click_button "登録"
        is_expected.to have_selector('h1', text: 'ユーザー登録')
      end
    end
  end

  describe "ユーザーの編集" do
    let!(:user) { create(:user) }
    let!(:other_user) { create(:other_user) }

    context "ログインしている場合" do
      before { sign_in(user) }
      context "正しい情報を入力した場合" do
        before do
          visit edit_user_path(user)
          fill_in "名前", with: "Foo Foo"
          fill_in "メールアドレス", with: "foofoo@example.com"
          fill_in "パスワード", with: "password"
          fill_in "パスワード（確認）", with: "password"
          click_button "変更"
        end
        example "ユーザー情報が更新される" do
          expect(user.reload.name).to eq "Foo Foo"
          expect(user.reload.email).to eq "foofoo@example.com"
        end
        example "サクセスメッセージが表示される" do
          is_expected.to have_selector('.alert-success', text: '編集に成功しました')
        end
        example "ユーザーページに遷移する" do
          is_expected.to have_current_path user_path(user)
        end
      end
      context "不正な情報を入力した場合" do
        before do
          visit edit_user_path(user)
          fill_in "名前", with: ""
          fill_in "メールアドレス", with: ""
          fill_in "パスワード", with: ""
          fill_in "パスワード（確認）", with: ""
          click_button "変更"
        end
        example "ユーザー情報が更新されない" do
          expect(user.reload.name).to_not eq "Foo Foo"
          expect(user.reload.email).to_not eq "foofoo@example.com"
        end
        example "エラーメッセージが表示される" do
          is_expected.to have_selector('.alert-danger')
        end
        example "ユーザー編集ページが描画される" do
          is_expected.to have_selector('h1', text: 'ユーザー情報の編集')
        end
      end
    end
    context "ログインしていない場合" do
      before { visit edit_user_path(user) }
      example "エラーメッセージが表示される" do
        is_expected.to have_selector('.alert-danger', text: 'ログインしてください')
      end
      example "ログインページに遷移する" do
        is_expected.to have_current_path login_path
      end
    end
    context "異なるユーザーでログインした場合" do
      before {
        sign_in(other_user)
        visit edit_user_path(user)
      }
      example "トップページに遷移する" do
        is_expected.to have_current_path root_path
      end
    end
  end

  describe "ユーザー一覧の表示" do
    before(:all) { 30.times { create(:test_user) } }
    let!(:user) { create(:user) }
    let!(:admin_user) { create(:admin_user) }

    context "ログインしている場合" do
      context "管理者ユーザーであるとき" do
        before {
          sign_in(admin_user)
          visit users_path
        }
        example "ページネーションが正確に作動している" do
          is_expected.to have_css 'ul.pagination'
          User.paginate(page: 1).each do |user|
            is_expected.to have_css('li', text: user.name)
          end
        end
        example "削除ボタンが表示されている" do
          is_expected.to have_selector('a', text: '削除')
        end
        describe "ユーザーの削除" do
          example "サクセスメッセージが表示される" do
            click_link '削除', match: :first
            is_expected.to have_selector('.alert-success', text: 'ユーザーを削除しました')
          end
          example "ユーザー一覧ページへ遷移" do
            click_link '削除', match: :first
            is_expected.to have_current_path users_path
          end
        end
      end
      context "通常のユーザーであるとき" do
        before {
          sign_in(user)
          visit users_path
        }
        example "ページネーションが正確に作動している" do
          is_expected.to have_css 'ul.pagination'
          User.paginate(page: 1).each do |user|
            is_expected.to have_css('li', text: user.name)
          end
        end
        example "削除ボタンが表示されていない" do
          is_expected.to_not have_selector('a', text: '削除')
        end
      end
    end
    context "ログインしていない場合" do
      before { visit users_path }
      example "エラーメッセージが表示される" do
        is_expected.to have_selector('.alert-danger', text: 'ログインしてください')
      end
      example "ログインページに遷移する" do
        is_expected.to have_current_path login_path
      end
    end
  end
end
