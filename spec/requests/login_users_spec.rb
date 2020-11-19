require 'rails_helper'

RSpec.describe "ユーザーのログイン", type: :request do
  let(:user) { create(:user) }
  context "Remember meチェックボックス" do
    example "チェックボックスがONのとき" do
      log_in_as(user, remember_me: '1')
      expect(cookies[:remember_token]).to_not eq nil
    end
    example "チェックボックスがOFFの時" do
      log_in_as(user, remember_me: '0')
      expect(cookies[:remember_token]).to eq nil
    end
  end
end
