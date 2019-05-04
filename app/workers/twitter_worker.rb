class TwitterWorker
  include Sidekiq::Worker
  require 'nokogiri'
  require 'open-uri'
  require 'nokogumbo'

  def perform(profile_id)
    profile = Profile.find(profile_id)
    doc = Nokogiri::HTML5.get(profile.twitter_url)

    profile.twitter_username = doc.css('.ProfileHeaderCard-screenname.u-inlineBlock.u-dir .username').text
    profile.twitter_description = doc.css('.ProfileHeaderCard-bio.u-dir').text

    profile.save
  rescue StandardError
    profile.twitter_username = 'Não foi possivel recuperar as informações'
    profile.twitter_description = 'Não foi possivel recuperar as informações'
    profile.save
  end
end
