require 'rails_helper'

RSpec.describe 'Users', type: :system do
  subject { page }

  describe 'ユーザーの登録' do
    before { visit signup_path }

    context '正確な情報を入力した場合' do
      before do
        fill_in '名前', with: 'Foobar'
        fill_in 'メールアドレス', with: 'foobar@example.com'
        fill_in 'パスワード', with: 'password'
        fill_in 'パスワード（確認）', with: 'password'
      end

      example '確認メッセージが表示される' do
        click_button '登録'
        is_expected.to have_selector('.alert-info', text: '入力されたメールアドレスにアカウント有効化用のメールをお送りいたしました。確認をお願いします。')
      end

      example 'トップページに遷移する' do
        click_button '登録'
        is_expected.to have_current_path root_path
      end
    end

    context '不正な情報を入力した場合' do
      before do
        visit signup_path
        fill_in '名前', with: ''
        fill_in 'メールアドレス', with: ''
        fill_in 'パスワード', with: ''
        fill_in 'パスワード（確認）', with: ''
      end

      example 'エラーメッセージが表示される' do
        click_button '登録'
        is_expected.to have_selector('.alert-danger')
      end

      example 'ユーザー登録ページが描画される' do
        click_button '登録'
        is_expected.to have_selector('h1', text: 'ユーザー登録')
      end
    end
  end

  describe 'ユーザーの編集' do
    let!(:user) { create(:user) }
    let!(:other_user) { create(:test_user) }

    context 'ログインしている場合' do
      before { sign_in(user) }

      context '正しい情報を入力した場合' do
        before do
          visit edit_user_path(user)
          fill_in '名前', with: 'Foo Foo'
          fill_in 'メールアドレス', with: 'foofoo@example.com'
          fill_in 'パスワード', with: 'password'
          fill_in 'パスワード（確認）', with: 'password'
          click_button '変更'
        end

        describe 'ユーザー情報が更新されること' do
          example '名前が更新される' do
            expect(user.reload.name).to eq 'Foo Foo'
          end

          example 'メールアドレスが更新される' do
            expect(user.reload.email).to eq 'foofoo@example.com'
          end
        end

        example 'サクセスメッセージが表示される' do
          is_expected.to have_selector('.alert-success', text: '編集に成功しました')
        end

        example 'ユーザーページに遷移する' do
          is_expected.to have_current_path user_path(user)
        end
      end

      context '不正な情報を入力した場合' do
        before do
          visit edit_user_path(user)
          fill_in '名前', with: ''
          fill_in 'メールアドレス', with: ''
          fill_in 'パスワード', with: ''
          fill_in 'パスワード（確認）', with: ''
          click_button '変更'
        end

        describe 'ユーザー情報が更新されないこと' do
          example '名前が更新されない' do
            expect(user.reload.name).to_not eq 'Foo Foo'
          end

          example 'メールアドレスが更新されない' do
            expect(user.reload.email).to_not eq 'foofoo@example.com'
          end
        end

        example 'エラーメッセージが表示される' do
          is_expected.to have_selector('.alert-danger')
        end

        example 'ユーザー編集ページが描画される' do
          is_expected.to have_selector('h1', text: 'ユーザー情報の編集')
        end
      end
    end

    context 'ログインしていない場合' do
      before { visit edit_user_path(user) }

      example 'エラーメッセージが表示される' do
        is_expected.to have_selector('.alert-danger', text: 'ログインしてください')
      end

      example 'ログインページに遷移する' do
        is_expected.to have_current_path login_path
      end
    end

    context '異なるユーザーでログインした場合' do
      before do
        sign_in(other_user)
        visit edit_user_path(user)
      end

      example 'トップページに遷移する' do
        is_expected.to have_current_path root_path
      end
    end
  end

  describe 'ユーザーの表示' do
    let!(:user) { create(:user, :activated) }

    before { create_list(:test_micropost, 51, user: user) }

    context 'ユーザーが有効化されている時' do
      before do
        log_in_as(user)
        visit user_path(user)
      end

      example 'ユーザーページにアクセスできる' do
        is_expected.to have_current_path user_path(user)
      end

      example 'ユーザーの名前が表示されている' do
        is_expected.to have_css('h1', text: user.name)
      end

      describe 'ユーザー投稿におけるページネーションの検証' do
        example 'paginationクラスが存在している' do
          is_expected.to have_css 'ul.pagination'
        end

        example '投稿の内容が表示されている' do
          user.microposts.paginate(page: 1).each do |micropost|
            is_expected.to have_css('.content', text: micropost.content)
          end
        end
      end
    end

    context 'ユーザーが有効化されていない時' do
      let!(:non_activated_user) { create(:test_user, :non_activated) }

      before do
        log_in_as(non_activated_user)
        visit user_path(non_activated_user)
      end

      example 'トップページに遷移する' do
        is_expected.to have_current_path root_path
      end
    end

    describe 'ステータスフィード' do
      let(:user_follower) { create(:test_user) }
      let(:other_user) { create(:test_user) }

      before do
        sign_in(user_follower)
        user_follower.active_relationships.create!(followed_id: user.id)
      end

      example 'フォローしているユーザーの投稿が存在する' do
        user.microposts.each do |following_post|
          expect(user_follower.feed).to be_include following_post
        end
      end

      example '自分自身の投稿が存在する' do
        user_follower_micropost = create(:test_micropost, user: user_follower)
        expect(user_follower.feed).to be_include user_follower_micropost
      end

      example 'フォローしていないユーザーの投稿が存在しない' do
        other_user_micropost = create(:test_micropost, user: other_user)
        expect(user_follower.feed).to_not be_include other_user_micropost
      end
    end
  end

  describe 'ユーザー一覧の表示' do
    before { create_list(:test_user, 29) }

    let!(:user) { create(:user) }
    let!(:admin_user) { create(:admin_user) }
    let!(:non_activated_user) { create(:test_user, :non_activated) }

    context 'ログインしている場合' do
      context '管理者ユーザーであるとき' do
        before do
          sign_in(admin_user)
          visit users_path
        end

        describe 'ページネーションの検証' do
          example 'paginationクラスが存在している' do
            is_expected.to have_css 'ul.pagination'
          end

          example 'ユーザーの名前が表示されている' do
            User.paginate(page: 1).each do |user|
              is_expected.to have_link user.name
            end
          end
        end

        example '削除ボタンが表示されている' do
          is_expected.to have_selector('a', text: '削除')
        end

        describe 'ユーザーの削除' do
          example 'サクセスメッセージが表示される' do
            click_link '削除', match: :first
            is_expected.to have_selector('.alert-success', text: 'ユーザーを削除しました')
          end

          example 'ユーザー一覧ページへ遷移' do
            click_link '削除', match: :first
            is_expected.to have_current_path users_path
          end
        end
      end

      context '通常のユーザーであるとき' do
        before do
          sign_in(user)
          visit users_path
        end

        describe 'ページネーションの検証' do
          example 'paginationクラスが存在している' do
            is_expected.to have_css 'ul.pagination'
          end

          example 'ユーザーの名前が表示されている' do
            User.paginate(page: 1).each do |user|
              is_expected.to have_link user.name
            end
          end
        end

        example '削除ボタンが表示されていない' do
          is_expected.to_not have_selector('a', text: '削除')
        end
      end

      example '有効化されていないユーザーが表示されない' do
        is_expected.to_not have_link user_path(non_activated_user)
      end
    end

    context 'ログインしていない場合' do
      before { visit users_path }

      example 'エラーメッセージが表示される' do
        is_expected.to have_selector('.alert-danger', text: 'ログインしてください')
      end

      example 'ログインページに遷移する' do
        is_expected.to have_current_path login_path
      end
    end
  end
end
