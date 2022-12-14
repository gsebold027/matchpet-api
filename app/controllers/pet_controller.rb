class PetController < ApplicationController
    before_action :authorize_request
    before_action :find_pet, except: %i[create index]
  
    # GET /pet
    def index
        pets_raw = Pet.all

        unless(params[:status].blank?)
          pets_raw = pets_raw.where(status: Status.where(normalized_name: params[:gender]))
        end

        unless(params[:species].blank?)
          pets_raw = pets_raw.where(specie: Specie.where(normalized_name: params[:species]))
        end

        unless(params[:gender].blank?)
          pets_raw = pets_raw.where(gender: Gender.where(normalized_name: params[:gender]))
        end

        unless(params[:minAge].blank?)
          pets_raw = pets_raw.where(age: params[:minAge]..)
        end

        unless(params[:maxAge].blank?)
          pets_raw = pets_raw.where(age: ..params[:maxAge])
        end

        unless(params[:size].blank?)
          pets_raw = pets_raw.where(size: Size.where(normalized_name: params[:size]))
        end

        unless(params[:special_need].blank?)
          pets_raw = pets_raw.where(special_need: params[:special_need])
        end

        @pets = []
        pets_raw.each do |pet|
          @pets << get_pet_info(pet)
        end
        render json: @pets, status: :ok
    end
  
    # GET /pet/{id}
    def show
      pet = get_pet_info @pet

      render json: pet, status: :ok
    end
  
    # POST /pet
    def create
        location = Location.new(lat: (params[:lat].blank? ? nil : params[:lat].to_f), lng: (params[:lng].blank? ? nil : params[:lng].to_f), address: params[:address])
        bd_location = Location.find_by(lat: location.lat, lng: location.lng)
  
        if bd_location.nil?
            unless location.save
                errors = location.errors.map { |error| { "#{error.attribute}" => error.full_message } }
                @response = { message: errors }
                render json: @response, status: :unprocessable_entity
                return
            end
        else
            location = bd_location
        end
    
        @pet = Pet.new(name: params[:name], specie: Specie.find_by(normalized_name: params[:species]), gender: Gender.find_by(normalized_name: params[:gender]), size: Size.find_by(normalized_name: params[:size]), status: Status.find_by(normalized_name: params[:status]), breed: params[:breed], age: (params[:age].blank? ? nil : params[:age].to_i), weight: (params[:weight].blank? ? nil : params[:weight].to_f), description: params[:description], neutered: (params[:neutered].blank? ? nil : params[:neutered].to_i), special_need: (params[:special_need].blank? ? nil : params[:special_need].to_i), photo: params[:photo], user: @current_user, location: location)
    
    
        if @pet.save
            @response = { message: 'Pet created successfully', id: @pet.id }
            render json: @response, status: :created
        else
            errors = @pet.errors.map { |error| { "#{error.attribute}" => error.full_message } }
    
            @response = { message: errors }
            render json: @response, status: :unprocessable_entity
        end
    end
  
    # PUT /pet/{id}
    def update
      render json: { error: 'unauthorized' }, status: :unauthorized unless @current_user.id == @pet.user.id
      location = Location.new(lat: (params[:lat].blank? ? nil : params[:lat].to_f), lng: (params[:lng].blank? ? nil : params[:lng].to_f), address: params[:address])
      bd_location = Location.find_by(lat: location.lat, lng: location.lng)
  
      if bd_location.nil?
          unless location.save
              errors = location.errors.map { |error| { "#{error.attribute}" => error.full_message } }
              @response = { message: errors }
              render json: @response, status: :unprocessable_entity
              return
          end
      else
          location = bd_location
      end
  
      if @pet.update(name: params[:name], specie: Specie.find_by(normalized_name: params[:species]), gender: Gender.find_by(normalized_name: params[:gender]), size: Size.find_by(normalized_name: params[:size]), status: Status.find_by(normalized_name: params[:status]), breed: params[:breed], age: (params[:age].blank? ? nil : params[:age].to_i), weight: (params[:weight].blank? ? nil : params[:weight].to_f), description: params[:description], neutered: (params[:neutered].blank? ? nil : params[:neutered].to_i), special_need: (params[:special_need].blank? ? nil : params[:special_need].to_i), photo: params[:photo], location: location)
          @response = { message: 'Pet updated successfully', id: @pet.id }
          render json: @response, status: :created
      else
          errors = @pet.errors.map { |error| { "#{error.attribute}" => error.full_message } }
  
          @response = { message: errors }
          render json: @response, status: :unprocessable_entity
      end
    end
  
    # DELETE /user/{id}
    def destroy
      render json: { error: 'unauthorized' }, status: :unauthorized unless @current_user.id ==  @pet.user.id
      @pet.destroy
      @response = { message: 'Pet deleted successfully' }
      render json: @response, status: :ok
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

    def get_pet_info pet
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
        photoUrl: pet.photo.url
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
