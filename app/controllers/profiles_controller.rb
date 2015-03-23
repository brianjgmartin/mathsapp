class ProfilesController < ApplicationController
  before_action :set_profile, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @profiles = Profile.all
    respond_with(@profiles)
  end

  def show
    respond_with(@profile)
  end

  def new
    @user = User.find(current_user.id)
     @profile = Profile.new
     @profile.user_id = @user.id
     @profile.save
  end

  def edit
  end

  def create
    @profile = Profile.new(profile_params)
    @profile.save
    respond_with(@profile)
  end

  def update
    @profile.update(profile_params)
redirect_to "/home/index"  end

  def destroy
    @profile.destroy
    respond_with(@profile)
  end

  def myprofile
 profile = Profile.find_by_user_id(current_user.id)

 if profile.nil?
 redirect_to "/profiles/new"
 else
 @user = User.find(current_user.id)
 @profile = Profile.find_by_user_id(@user.id)
 redirect_to "/home/index"
 end
 end

  private
    def set_profile
      @profile = Profile.find(params[:id])
    end

    def profile_params
      params.require(:profile).permit(:firstname, :lastname, :user_id)
    end
end
