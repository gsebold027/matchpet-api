class UserController < ApplicationController
  def create
    location = Location.new(location_params)
    bd_location = Location.find_by(lat: location.lat, lng: location.lng)

    if bd_location.nil?
      location.save
    else
      location = bd_location
    end

    @user = User.new(user_params)

    @user.location = location

    if @user.save
      @response = { message: 'User created successfully' }
      render json: @response, status: :created
    else
      errors = @user.errors.map { |error| { "#{error.attribute}" => error.full_message } }

      @response = { message: errors }
      render json: @response, status: :bad_request
    end
  end

  def update
    @id = params[:id]

    if @id.nil? || @id.empty? || @id.is_a?(Numeric)
      @response = { message: 'User id must be provided' }
      render json: @response, status: :unprocessable_entity
      return
    end

    bd_user = User.find_by(id: @id)

    if bd_user.nil?
      @response = { message: 'Unvalid user id' }
      render json: @response, status: :unprocessable_entity
      return
    end

    @user = User.new(user_params)

    location = Location.new(location_params)
    bd_location = Location.find_by(lat: location.lat, lng: location.lng)

    if bd_location.nil?
      location.save
    else
      location = bd_location
    end

    @user.location = location

    if @user.save
      @response = { message: 'User updated successfully' }
      render json: @response, status: :ok
    else
      errors = @user.errors.map { |error| { "#{error.attribute}" => error.full_message } }

      @response = { message: errors }
      render json: @response, status: :bad_request
    end
  end

  def delete
    @id = params[:id]

    if @id.nil? || @id.empty? || @id.is_a?(Numeric)
      @response = { message: 'User id must be provided' }
      render json: @response, status: :unprocessable_entity
      return
    end

    user = User.find_by(id: @id)

    if user.nil?
      @response = { message: 'Unvalid user id' }
      render json: @response, status: :unprocessable_entity
      return
    end

    user.delete
    @response = { message: 'User deleted successfully' }
    render json: @response, status: :ok
  end

  private

  def location_params
    params.require(:location).permit(:lat, :lng, :address)
  end

  def user_params
    params.require(:user).permit(:name, :phone, :email, :password, :password_confirmation)
  end
end
