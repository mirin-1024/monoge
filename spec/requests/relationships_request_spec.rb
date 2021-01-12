require 'rails_helper'

RSpec.describe "Relationships", type: :request do
  subject { response }

  let(:user) { create(:user) }
  let(:other_user) { create(:test_user) }

  describe "#create" do
    context "ログインしていない場合" do
      example "関係が保存されない" do
        expect do
          post relationships_path
        end.to change(Relationship, :count).by(0)
      end

      example "ログインページにリダイレクト" do
        post relationships_path
        is_expected.to redirect_to login_url
      end
    end
  end

  describe "#destroy" do
    before { user.following << other_user }

    context "ログインしていない場合" do
      example "関係が削除されない" do
        expect do
          delete relationship_path(other_user)
        end.to change(Relationship, :count).by(0)
      end

      example "ログインページにリダイレクト" do
        delete relationship_path(other_user)
        is_expected.to redirect_to login_url
      end
    end
  end
end
