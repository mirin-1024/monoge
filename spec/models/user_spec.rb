require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

  context "正しい情報を入力した場合" do
    example "正しい情報でユーザーが作成できる" do
      expect(build(:user)).to be_valid
    end
  end

  context "不適切な情報を入力した場合" do
    context "名前が不適切な場合" do
      example "名前が入力されていない" do
        expect(build(:user, name: "")).to_not be_valid
      end

      example "名前が50文字を超過している" do
        expect(build(:user, name: "a" * 51)).to_not be_valid
      end
    end

    context "メールアドレスが不適切な場合" do
      example "空白では登録できない" do
        expect(build(:user, email: "")).to_not be_valid
      end

      example "255字を超過していると登録できない" do
        expect(build(:user, email: "a" * 244 + "@example.com")).to_not be_valid
      end

      example "~@~.~ 以外の形式では登録できない" do
        invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                               foo@bar_baz.com foo@bar+baz.com]
        invalid_addresses.each do |invalid_address|
          expect(build(:user, email: invalid_address)).to_not be_valid
        end
      end

      example "重複するメールアドレスは登録できない" do
        expect(build(:other_user, email: user.email)).to_not be_valid
      end

      example "大文字のメールアドレスが、登録されている小文字のメールアドレスと重複すると登録できない" do
        mixed_case_email = "Foo@ExAMPle.CoM"
        user = create(:user, email: mixed_case_email.downcase)
        expect(build(:other_user, email: mixed_case_email)).to_not be_valid
      end
    end

    context "パスワードが不適切な場合" do
      example "空白では登録できない" do
        expect(build(:user, password: "", password_confirmation: "")).to_not be_valid
      end

      example "6字未満では登録できない" do
        expect(build(:user, password: "a" * 5, password_confirmation: "a" * 5)).to_not be_valid
      end
    end
  end

  describe "セキュアなパスワードの実装" do
    example "パスワードが確認用のパスワードと異なる場合登録できない" do
      expect(build(:user, password: "password", password_confirmation: "passward")).to_not be_valid
    end

    example "パスワードが暗号化されて保存される" do
      expect(user.password_digest).to_not eq user.password
    end
  end

  describe "記憶ダイジェスト" do
    context "nilの場合" do
      example "falseを返すことができる" do
        expect(user.authenticated?(:remember, '')).to be_falsey
      end
    end
  end

  describe "ユーザーの投稿" do
    let!(:user) { create(:user) }
    # let(:micropost) { create(:micropost, user: user) }

    example "ユーザーが削除された時に削除される" do
      expect do
        user.destroy
      end.to change(Micropost, :count).by(-1)
    end
  end

  describe "フォロー機能" do
    let!(:user) { create(:user) }
    let!(:other_user) { create(:other_user) }

    describe "他のユーザーをフォロー" do
      example "フォローできる" do
        user.follow(other_user)
        expect(user.following?(other_user)).to be_truthy
      end

      example "フォロワーである" do
        user.follow(other_user)
        other_user.followers.include?(user)
      end

      example "フォロー解除できる" do
        user.follow(other_user)
        user.unfollow(other_user)
        expect(user.following?(other_user)).to be_falsey
      end
    end
  end
end
