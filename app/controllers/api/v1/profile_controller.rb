class Api::V1::ProfileController < ApplicationController
  def index
    #fetch all profiles
    if params[:search] then
      terms = params[:search].split().map{|val| "%#{val}%"}
      profiles = Profile.search(terms)
    else
      profiles = Profile::all()
    end
    

    return render :json => {:profiles => profiles}
  end

  def show
    #fetch profile
    return render :json => {:profile => Profile::find(params[:id])}
  end

  def create
    #creates a new profile object to validation and persistence
    profile = Profile.new(name: params[:profile][:name], twitter_url: params[:profile][:twitter_url])

    #verify if there's any error at profile fields and return if they exists
    return render :json => {:errors => profile.errors}, :status => :bad_request if not profile.valid?
    

    #persist the profile at database
    profile.save

    #return the persisted profile
    return render :json => {:profile => profile}, :status => :created

  end

  def update
    #Gets existing profile object to update, validate and persist data
    profile = Profile::find(params[:id])

    #update fetched profile data 
    profile.name = params[:profile][:name] if params[:profile][:name]
    profile.twitter_url = params[:profile][:twitter_url] if params[:profile][:twitter_url]
    profile.twitter_username = params[:profile][:twitter_username] if params[:profile][:twitter_username]
    profile.twitter_description = params[:profile][:twitter_description] if params[:profile][:twitter_description]

    #verify if there's any error at profile fields and return if they exists
    return render :json => {:errors => profile.errors}, :status => :bad_request if not profile.valid?
    
    #persist the profile at database
    profile.save

    #return the persisted profile
    return render :json => {:profile => profile}, :status => :success
  end

  def destroy

    #Get  exiting profile to delete
    profile = Profile::find(params[:id])

    #delete the profile
    profile.destroy

    #return status with no content
    return render :json => '', :status => :no_content
  end
end
