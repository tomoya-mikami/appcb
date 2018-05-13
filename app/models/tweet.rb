class Tweet < ApplicationRecord
  def self.get_twitter_client
    client = Twitter::REST::Client.new(
      consumer_key:        Rails.application.secrets.twitter_consumer_key,
      consumer_secret:     Rails.application.secrets.twitter_consumer_secret,
      access_token:        Rails.application.secrets.twitter_access_token,
      access_token_secret: Rails.application.secrets.twitter_access_token_secret,
    )
  end
end
