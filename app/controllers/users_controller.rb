class UsersController < ApplicationController
  before_action :signed_in_user, only: [:show]
  before_action :correct_user,   only: [:edit, :update]

  def show
    @user = User.find_by_username(params[:id])

    @locations = Location.all

    # User's created locations
    @created_locations = Location.where(user_id: @user.id).sort_by{|location| distance(location)}
    @default_created_location = @created_locations.shift

    # User's pending locations
    @pending_locations ||= Array.new
    @user.pending_locations.each do |pending_location| 
      @pending_locations.push(Location.find(pending_location.location_id))
    end
    @pending_locations = @pending_locations.sort_by{|location| distance(location)}
    @default_pending_location = @pending_locations.shift
    
    # User's completed locations
    @completed_locations ||= Array.new
    @user.user_responses.each do |user_response|
      @completed_locations.push(Location.find(user_response.location_id))
    end
    @completed_locations = @completed_locations.sort_by{|location| distance(location)}
    @default_completed_location = @completed_locations.shift

    
    
  end

  def created_location
    @location = Location.find(params[:id])
    @distance = distance(@location)
    if @location.user_responses
      @sum = 0
      @location.user_responses.each do |user_response|
        @sum += user_response.rating
      end
      @avg_rating = (@sum.to_f / @location.user_responses.length).round(1)
    end
    raise ActionController::RoutingError.new('Not Found') unless @location
    respond_to do |format|
      format.js
    end
  end

  def pending_location
    @location = Location.find(params[:id])
    @distance = distance(@location)
    if @location.user_responses
      @sum = 0
      @location.user_responses.each do |user_response|
        @sum += user_response.rating
      end
      @avg_rating = (@sum.to_f / @location.user_responses.length).round(1)
    end
    raise ActionController::RoutingError.new('Not Found') unless @location
    respond_to do |format|
      format.js
    end
  end

  def completed_location
    @location = Location.find(params[:id])
    @distance = distance(@location)
    if @location.user_responses
      @sum = 0
      @location.user_responses.each do |user_response|
        @sum += user_response.rating
      end
      @avg_rating = (@sum.to_f / @location.user_responses.length).round(1)
    end
    raise ActionController::RoutingError.new('Not Found') unless @location
    respond_to do |format|
      format.js
    end
  end
    

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to ViewPoint!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :username, :password,
                                   :password_confirmation, :gps_location)
    end

    def distance(location)
      if current_user
        @current = current_user.gps_location.split(", ").map(&:to_f)
      else
        @current = [42.35689883623664, -71.09561786055565]
      end
      @target = location.gps_location.split(", ").map(&:to_f)
      distance_function @current, @target
    end

    def distance_function a, b
      rad_per_deg = Math::PI/180  # PI / 180
      rkm = 6371                  # Earth radius in kilometers
      rm = rkm * 1000             # Radius in meters

      dlon_rad = (b[1]-a[1]) * rad_per_deg  # Delta, converted to rad
      dlat_rad = (b[0]-a[0]) * rad_per_deg

      lat1_rad, lon1_rad = a.map! {|i| i * rad_per_deg }
      lat2_rad, lon2_rad = b.map! {|i| i * rad_per_deg }

      a = Math.sin(dlat_rad/2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon_rad/2)**2
      c = 2 * Math.asin(Math.sqrt(a))

      rm * c # Delta in meters
    end

    # Before filters

    def correct_user
      @user = User.find_by_username(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
end