class LocationsController < ApplicationController
  before_action :signed_in_user, only: [:new, :create]
  before_action :correct_user,   only: [:edit, :update]
  def index
    # Shift removes and returns the front element
    @locations = Location.all.sort_by{|location| distance(location)}
    @default_location = @locations.shift
  end

  def new
  	@location = Location.new
  end

  def create
    @location = Location.new(location_params)
    if @location.save
      flash[:success] = "Viewpoint created successfully!"
      redirect_to locations_path
    else
      render 'new'
    end
  end

  def show
    @location = Location.find(params[:id])
    @user_responses = @location.user_responses
  end

  def preview
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

  def showcase
    @locations = Location.all
  end

  def edit
  end

  def update
    if @location.update_attributes(location_params)
      flash[:success] = "Viewpoint updated"
      redirect_to @location
    else
      render 'edit'
    end
  end

  private

    def location_params
      params.require(:location).permit(:title, :description, :gps_location, :difficulty, :hints, :suggestions, :image, :image_file_name, :image_content_type, :image_file_size, :image_updated_at, :user_id )
    end

    def correct_user
      @location = Location.find(params[:id])
      @user = @location.user
      redirect_to(root_url) unless current_user?(@user)
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



    
end
