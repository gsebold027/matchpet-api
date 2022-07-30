class UserController < ApplicationController
  def new
    location = Location.new(location_params)
    bd_location = Location.find_by(lat: location.lat, lng: location.lng)

    if bd_location.nil?
      location.save
    else
      location = bd_location
    end

    user = User.new(user_params)

    if User.find_by(email: user.email)
      @response = { status: 409, message: 'Email address already exists' }
      render json: @response, status: :conflict
      return
    end

    user.location = location

    if user.save
      @response = { status: 201, message: 'User created successfully' }
      render json: @response, status: :created
    end
  end

  private

  def location_params
    params.require(:location).permit(:lat, :lng, :address)
  end

  def user_params
    params.require(:user).permit(:name, :phone, :email, :password, :password_confirmation)
  end
end
