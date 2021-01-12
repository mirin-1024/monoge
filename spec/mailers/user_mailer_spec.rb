require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "アカウントの有効化メール" do
    let(:mail) { UserMailer.account_activation(user) }
    let(:user) { create(:user) }

    describe "ヘッダーが適切であること" do
      example "件名が適切である" do
        expect(mail.subject).to eq("Welcome to monoge!")
      end

      example "メールアドレスが適切である" do
        expect(mail.to).to eq([user.email])
      end

      example "送信元が適切である" do
        expect(mail.from).to eq(["noreply@example.com"])
      end
    end

    describe "内容が適切であること" do
      example "ユーザー名が表示されている" do
        expect(mail.body.encoded).to match user.name
      end

      example "アカウントの有効化トークンが表示されている" do
        expect(mail.body.encoded).to match user.activation_token
      end

      example "エスケープされたメールアドレスが表示されている" do
        expect(mail.body.encoded).to match CGI.escape(user.email)
      end
    end
  end

  describe "パスワードの再設定メール" do
    let(:mail) { UserMailer.password_reset(user) }
    let(:user) { create(:user) }

    before { user.reset_token = User.new_token }

    describe "ヘッダーが適切であること" do
      example "件名が適切である" do
        expect(mail.subject).to eq("Password Reset")
      end

      example "メールアドレスが適切である" do
        expect(mail.to).to eq([user.email])
      end

      example "送信元が適切である" do
        expect(mail.from).to eq(["noreply@example.com"])
      end
    end

    describe "内容が適切であること" do
      example "パスワードの再設定トークンが表示されている" do
        expect(mail.body.encoded).to match user.reset_token
      end

      example "エスケープされたメールアドレスが表示されている" do
        expect(mail.body.encoded).to match CGI.escape(user.email)
      end
    end
  end
end
