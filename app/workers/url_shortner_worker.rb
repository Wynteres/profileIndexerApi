class UrlShortnerWorker
  include Sidekiq::Worker
  require 'open-uri'

  def perform(profile_id)
    profile = Profile.find(profile_id)

    api_key = '80d1656b3de2f8de8813932d739fe13b8a055'
    response = ActiveSupport::JSON.decode(
      URI.parse("https://cutt.ly/api/api.php?key=#{api_key}&short=#{profile.twitter_url}").read
    )

    if response['url']['status'] == 7
      profile.twitter_url = response['url']['shortLink']
      profile.save
    end
  rescue StandardError
  end
end
