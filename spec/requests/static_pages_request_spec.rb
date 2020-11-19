require 'rails_helper'

RSpec.describe "StaticPages", type: :request do

  describe "GET /home" do
    example "GETリクエストが成功" do
      get "/"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /contact" do
    example "GETリクエストが成功" do
      get "/contact"
      expect(response).to have_http_status(:success)
    end
  end

end
