class Api::V1::ProfileController < ApplicationController
  def index
    #fetch all profiles
    return render :json => {:profiles => Profile::all()}
  end

  def show
    #fetch profile
    return render :json => {:profile => Profile::find(params[:id])}
  end

  def create
    #creates a new profile object to validation and persistence
    profile = Profile.new(name: params[:profile][:name], twitterUrl: params[:profile][:twitterUrl])

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
    profile.name = params[:profile][:name]
    profile.twitterUrl = params[:profile][:twitterUrl]
    profile.twitterUsername = params[:profile][:twitterUsername]
    profile.twitterDescription = params[:profile][:twitterDescription]

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
