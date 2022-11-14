class PetController < ApplicationController
    before_action :authorize_request
    before_action :find_pet, except: %i[create index]
  
    # GET /user
    def index
        pets_raw = Pet.all

        unless(params[:species].nil? || params[:species].empty?)
          pets_raw = pets_raw.where(species: params[:species])
        end

        unless(params[:gender].nil? || params[:gender].empty?)
          pets_raw = pets_raw.where(gender: params[:gender])
        end

        unless(params[:minAge].nil?)
          pets_raw = pets_raw.where(age: params[:minAge]..)
        end

        unless(params[:maxAge].nil?)
          pets_raw = pets_raw.where(age: ..params[:maxAge])
        end

        unless(params[:size].nil? || params[:size].empty?)
          pets_raw = pets_raw.where(size: params[:size])
        end

        unless(params[:special_need].nil?)
          pets_raw = pets_raw.where(special_need: params[:special_need])
        end

        @pets = []
        pets_raw.each do |pet|
          @pets << {
            id: pet.id,
            name: pet.name,
            species: pet.species,
            gender: pet.gender,
            size: pet.size,
            status: pet.status,
            breed: pet.breed,
            age: pet.age,
            weight: pet.weight,
            description: pet.description,
            neutered: pet.neutered,
            special_need: pet.special_need,
            location: pet.location,
            owner: pet.user,
            photoUrl: pet.photo.url
          }
        end
        render json: @pets, status: :ok
    end
  
    # GET /user/{id}
    def show
        full_pet = {
          id: @pet.id,
          name: @pet.name,
          species: @pet.species,
          gender: @pet.gender,
          size: @pet.size,
          status: @pet.status,
          breed: @pet.breed,
          age: @pet.age,
          weight: @pet.weight,
          description: @pet.description,
          neutered: @pet.neutered,
          special_need: @pet.special_need,
          location: @pet.location,
          owner: @pet.user,
          photoUrl: @pet.photo.url
        }
      render json: full_pet.to_json, status: :ok
    end
  
    # POST /pet
    def create
        params
        location = Location.new(lat: params[:lat].to_f, lng: params[:lng].to_f, address: params[:address])
        bd_location = Location.find_by(lat: location.lat, lng: location.lng)
  
        if bd_location.nil?
            location.save
        else
            location = bd_location
        end
    
        @pet = Pet.new(name: params[:name], species: params[:species].to_i, gender: params[:gender].to_i, size: params[:size].to_i, status: params[:status].to_i, breed: params[:breed], age: params[:age].to_i, weight: params[:weight].to_f, description: params[:description], neutered: params[:neutered].to_i, special_need: params[:special_need].to_i, photo: params[:photo])
    
        @pet.location = location
        @pet.user = @current_user
    
        if @pet.save
            @response = { message: 'Pet created successfully', id: @pet.id }
            render json: @response, status: :created
        else
            errors = @pet.errors.map { |error| { "#{error.attribute}" => error.full_message } }
    
            @response = { message: errors }
            render json: @response, status: :unprocessable_entity
        end
    end
  
    # PUT /user/{id}
    def update
    #   render json: { error: 'unauthorized' }, status: :unauthorized unless @current_user.id == @user.id
    #   location = Location.new(location_params)
    #   bd_location = Location.find_by(lat: location.lat, lng: location.lng)
  
    #   if bd_location.nil?
    #     location.save
    #   else
    #     location = bd_location
    #   end
  
    #   @user.location = location
  
    #   if @user.update(user_params)
    #     @response = { message: 'User updated successfully' }
    #     render json: @response, status: :ok
    #   else
    #     errors = @user.errors.map { |error| { "#{error.attribute}" => error.full_message } }
  
    #     @response = { message: errors }
    #     render json: @response, status: :unprocessable_entity
    #   end
    end
  
    # DELETE /user/{id}
    def destroy
    #   render json: { error: 'unauthorized' }, status: :unauthorized unless @current_user.id == @user.id
    #   @user.destroy
    #   @response = { message: 'User deleted successfully' }
    #   render json: @response, status: :ok
    end
  
    private
  
    def find_pet
      @pet = Pet.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { errors: 'Pet not found' }, status: :not_found
    end
  
    def location_params
      params.permit(:lat, :lng, :address)
    end
  
    def pet_params
      params.permit()
    end
end
