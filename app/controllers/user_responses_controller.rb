class UserResponsesController < ApplicationController
  before_action :signed_in_user, only: [:new, :show, :create]
  before_action :correct_user,   only: [:edit, :update]

  def new
    @location = Location.find(params[:format])
    @user_response = UserResponse.new
  end

  def create
    @user_response = UserResponse.new(user_response_params)
    @location = Location.find(@user_response.location_id)
    unless current_user.pending_locations.where(location_id: @location.id).blank?
      current_user.pending_locations.find_by_location_id(@location.id).destroy
    end
    if @user_response.save
      flash[:success] = "Completed viewpoint added to list!"
      redirect_to @user_response.location
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user_response.update_attributes(user_response_params)
      flash[:success] = "Viewpoint updated"
      redirect_to @user_response.location
    else
      render 'edit'
    end
  end

  private

    def user_response_params
      params.require(:user_response).permit(:comments, :rating, :image, :image_file_name, :image_content_type, :image_file_size, :image_updated_at, :user_id, :location_id)
    end

    # Before filters

    def correct_user
      @user_response = UserResponse.find(params[:id])
      @user = @user_response.user
      @location  = @user_response.location
      redirect_to(root_url) unless current_user?(@user)
    end
end