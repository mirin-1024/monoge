require 'rails_helper'

RSpec.describe Relationship, type: :model do
  let(:user) { create(:user) }
  let(:other_user) { create(:test_user) }
  let!(:relationship) { create(:relationship, follower_id: user.id, followed_id: other_user.id) }

  example 'ユーザーをフォローできる' do
    expect(relationship).to be_valid
  end

  example 'フォロワーのIDが存在する' do
    relationship.follower_id = nil
    expect(relationship).to_not be_valid
  end

  example 'フォローしているユーザーのIDが存在する' do
    relationship.followed_id = nil
    expect(relationship).to_not be_valid
  end
end
