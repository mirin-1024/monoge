require 'rails_helper'

RSpec.describe "SignupUsers", type: :request do
  let!(:user) { create(:user) }
  context "ユーザー作成時" do
    example "ログインの確認" do
      post login_path, params: { session: { email: user.email,
                                            password: user.password} }
      expect(is_logged_in?).to be_truthy
    end
  end
end
