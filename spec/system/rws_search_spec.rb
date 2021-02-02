require 'rails_helper'

RSpec.describe 'RwsSearch', type: :system do
  subject { page }

  let(:user) { create(:user) }
  let(:list_item) { create(:list_item, user: user) }

  describe '楽天APIによる商品検索' do
    let(:keyword) { '楽天' }

    before do
      sign_in(user)
      visit lists_search_path
      find('#rws-search-form').set(keyword)
      click_on '検索'
    end

    example '検索結果が表示される' do
      is_expected.to have_content keyword
    end

    describe 'モノリストに追加' do
      before { click_on '追加', match: :first }

      example 'モノリストページに遷移する' do
        is_expected.to have_current_path lists_path
      end

      example '検索した商品がリストに追加される' do
        is_expected.to have_content keyword
      end
    end
  end
end
