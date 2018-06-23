require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do

  describe "GET #map" do
    it "returns http success" do
      get :map
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #analytics" do
    it "returns http success" do
      get :analytics
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #image" do
    it "returns http success" do
      get :image
      expect(response).to have_http_status(:success)
    end
  end

end
