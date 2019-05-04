# Controller for Profile model action
class Api::V1::ProfileController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :return_not_found
  
  def return_not_found
    render json: '', status: :not_found
  end

  def index
    # fetch all profiles
    if params[:search]
      terms = params[:search].split.map { |val| "%#{val}%" }
      profiles = Profile.search(terms)
    else
      profiles = Profile.all
    end

    render json: { profiles: profiles }
  end

  def show
    # fetch profile
    profile = Profile.find(params[:id])
    render json: { profile: profile }
  end

  def create
    # creates a new profile object to validation and persistence
    profile = Profile.new(name: params[:profile][:name], twitter_url: params[:profile][:twitter_url])

    # verify if there's any error at profile fields and return if they exists
    return render json: { errors: profile.errors }, status: :bad_request unless profile.valid?

    # persist the profile at database
    profile.save

    # passes the profile for twitterworker to fetch twitter shortned url and save asyncs
    UrlShortnerWorker.perform_async(profile.id)

    # passes the profile for twitterworker to fetch profile info and save asyncs
    TwitterWorker.perform_async(profile.id)

    # return the persisted profile
    render json: { profile: profile }, status: :created
  end

  def update
    # Gets existing profile object to update, validate and persist data
    profile = Profile.find(params[:id])

    # verify if the twitter profile URL has changed and mark to use after saving profile changes
    twitterUrlHasChanged = true unless params[:profile][:twitter_url].equal?(profile.twitter_url)

    # update fetched profile data
    profile.name = params[:profile][:name] if params[:profile][:name]
    profile.twitter_url = params[:profile][:twitter_url] if params[:profile][:twitter_url]
    profile.twitter_username = params[:profile][:twitter_username] if params[:profile][:twitter_username]
    profile.twitter_description = params[:profile][:twitter_description] if params[:profile][:twitter_description]

    # verify if there's any error at profile fields and return if they exists
    return render json: { errors: profile.errors }, status: :bad_request unless profile.valid?

    # persist the profile at database
    profile.save

    # passes the profile for twitterworker to fetch profile info and save asyncs IF the url has changed
    if twitterUrlHasChanged
      UrlShortnerWorker.perform_async(profile.id)
      TwitterWorker.perform_async(profile.id)
    end

    # return the persisted profile
    render json: { profile: profile }, status: :success
  end

  def destroy
    # Get existing profile to delete
    profile = Profile.find(params[:id])

    # delete the profile
    profile.destroy

    # return status with no content
    render json: '', status: :no_content
  end
end
