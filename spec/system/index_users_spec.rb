require 'rails_helper'

RSpec.describe "ユーザー一覧", type: :system do
  let(:user) { create(:user) }
  let(:non_admin) { create(:test_user) }
  let(:admin) { create(:test_user, :admin) }
  before(:all) { 30.times { create(:test_user) } }
  subject { page }
  example "ページネーションが正確に作動している" do
    log_in(user)
    visit users_path
    is_expected.to have_css 'ul.pagination'
    User.paginate(page: 1).each do |user|
      is_expected.to have_css('li', text: user.name)
    end
  end
  example "管理者ユーザーでない場合のユーザー一覧" do
    log_in_as(non_admin)
    visit users_path
    is_expected.to have_selector('a', text: 'delete', count: '0')
  end
end
