class PendingLocationsController < ApplicationController
  before_action :signed_in_user
  
  
  def create
    @location = Location.find(params[:pending_location][:location_id])
    PendingLocation.create!(user_id: current_user.id, location_id: @location.id)
    respond_to do |format|
      format.html { redirect_to @location }
      format.js
    end
  end

  def destroy
    @location = Location.find(params[:pending_location][:location_id])
    current_user.pending_locations.find_by_location_id(@location.id).destroy
    respond_to do |format|
      format.html { redirect_to @location }
      format.js
    end
  end


end