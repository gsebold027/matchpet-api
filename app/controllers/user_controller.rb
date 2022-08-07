class UserController < ApplicationController
  before_action :authorize_request, except: :create
  before_action :find_user, except: %i[create index]

  # GET /users
  def index
    @users = User.all
    render json: @users, status: :ok
  end

  # GET /users/{username}
  def show
    user = {}
    user[:id] = @user.id
    user[:name] = @user.name
    user[:email] = @user.email
    user[:phone] = @user.phone
    user[:location] = { lat: @user.location.lat, lng: @user.location.lng }
    render json: user, status: :ok
  end

  # POST /users
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
      render json: @response, status: :unprocessable_entity
    end
  end

  # PUT /users/{username}
  def update
    location = Location.new(location_params)
    bd_location = Location.find_by(lat: location.lat, lng: location.lng)

    if bd_location.nil?
      location.save
    else
      location = bd_location
    end

    @user.location = location

    if @user.update(user_params)
      @response = { message: 'User updated successfully' }
      render json: @response, status: :ok
    else
      errors = @user.errors.map { |error| { "#{error.attribute}" => error.full_message } }

      @response = { message: errors }
      render json: @response, status: :unprocessable_entity
    end
  end

  # DELETE /users/{username}
  def delete
    @user.destroy
    @response = { message: 'User deleted successfully' }
    render json: @response, status: :ok
  end

  private

  def find_user
    @user = User.find(params[:_id])
  rescue ActiveRecord::RecordNotFound
    render json: { errors: 'User not found' }, status: :not_found
  end

  def location_params
    params.require(:location).permit(:lat, :lng, :address)
  end

  def user_params
    params.require(:user).permit(:name, :phone, :email, :password, :password_confirmation)
  end
end
