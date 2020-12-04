require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "アカウントの有効化メール" do
    let(:mail) { UserMailer.account_activation(user) }
    let(:user) { create(:user) }

    example "ヘッダーが適切である" do
      expect(mail.subject).to eq("Welcome to monoge!")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["noreply@example.com"])
    end

    example "内容が適切である" do
      expect(mail.body.encoded).to match user.name
      expect(mail.body.encoded).to match user.activation_token
      expect(mail.body.encoded).to match CGI.escape(user.email)
    end
  end

  describe "パスワードの再設定メール" do
    let(:mail) { UserMailer.password_reset(user) }
    let(:user) { create(:user) }
    before { user.reset_token = User.new_token }

    example "ヘッダーが適切である" do
      expect(mail.subject).to eq("Password Reset")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["noreply@example.com"])
    end

    example "内容が適切である" do
      expect(mail.body.encoded).to match user.reset_token
      expect(mail.body.encoded).to match CGI.escape(user.email)
    end
  end
end
