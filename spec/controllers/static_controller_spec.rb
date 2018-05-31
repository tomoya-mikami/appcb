require 'rails_helper'

RSpec.describe StaticController, type: :controller do

  describe "GET #map" do
    it "returns http success" do
      get :map
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #check" do
    it "returns http success" do
      get :check
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #hearing" do
    it "returns http success" do
      get :hearing
      expect(response).to have_http_status(:success)
    end
  end

end
