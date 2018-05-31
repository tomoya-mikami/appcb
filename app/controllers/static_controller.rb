class StaticController < ApplicationController
  def map
    @google_map_api_key = Rails.application.secrets.google_map_api_key
  end

  def check
  end

  def hearing
  end
end
