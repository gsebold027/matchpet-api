class UserController < ApplicationController
  before_action :authorize_request, except: :create
  before_action :find_user, except: %i[create index]

  # GET /user
  def index
    @users = User.all
    render json: @users, status: :ok
  end

  # GET /user/{id}
  def show
    user = {}
    user[:id] = @user.id
    user[:name] = @user.name
    user[:email] = @user.email
    user[:phone] = @user.phone
    user[:location] = { lat: @user.location.lat, lng: @user.location.lng, address: @user.location.address }
    render json: user, status: :ok
  end

  # POST /user
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

  # PUT /user/{id}
  def update
    render json: { error: 'unauthorized' }, status: :unauthorized unless @current_user.id == @user.id
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

  # DELETE /user/{id}
  def destroy
    render json: { error: 'unauthorized' }, status: :unauthorized unless @current_user.id == @user.id
    @user.destroy
    @response = { message: 'User deleted successfully' }
    render json: @response, status: :ok
  end

  def favorites
    pets = @user.favorite_pets.map { |favorite| get_pet_info(favorite.pet) }

    render  json: pets, status: :ok
  end

  def add_favorite
    pet = Pet.find_by(id: params[:pet_id])

    if pet.nil?
      render json: { error: 'Pet not found' }, status: :unprocessable_entity
      return
    end
    
    new_favorite = FavoritePet.new(user: @user, pet:)
    if new_favorite.save
      @response = { message: 'Pet favorited successfully' }
      render json: @response, status: :ok
    else
      errors = new_favorite.errors.map { |error| { "#{error.attribute}" => error.full_message } }

      @response = { message: errors }
      render json: @response, status: :unprocessable_entity
    end  
  end

  def remove_favorite
    pet = Pet.find_by(id: params[:pet_id])

    favorite = FavoritePet.find_by(user: @user, pet:)

    if favorite.nil?
      render json: { error: 'Relation not found' }, status: :unprocessable_entity
      return
    end
    
    if favorite.destroy
      @response = { message: 'Favorite pet removed successfully' }
      render json: @response, status: :ok
    else
      errors = favorite.errors.map { |error| { "#{error.attribute}" => error.full_message } }

      @response = { message: errors }
      render json: @response, status: :unprocessable_entity
    end
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

  def get_pet_info(pet)
    pet_info = {
        id: pet.id,
        name: pet.name,
        specie: pet.specie.slice(:id, :display_name, :normalized_name),
        gender: pet.gender.slice(:id, :display_name, :normalized_name),
        size: pet.size.slice(:id, :display_name, :normalized_name),
        status: pet.status.slice(:id, :display_name, :normalized_name),
        breed: pet.breed,
        age: pet.age,
        weight: pet.weight,
        description: pet.description,
        neutered: pet.neutered,
        special_need: pet.special_need,
        location: pet.location.slice(:id, :lat, :lng, :address),
        photoUrl: pet.photo.url,
        is_user_favorite: FavoritePet.find_by(user: @current_user, pet:).nil? ? 0 : 1
    }
    pet_info[:user] = {
        id: pet.user.id,
        name: pet.user.name,
        phone: pet.user.phone,
        email: pet.user.email,
        location: pet.user.location.slice(:id, :lat, :lng, :address)
    }

    pet_info
  end

end
