class InterestController < ApplicationController
    before_action :authorize_request

    # GET /interest
    def index
        interests_raw = Interest.all
        unless params[:petId]
            find_pet
            interests_raw = interests_raw.where(pet: @pet)
        end

        unless params[:userId]
            find_user
            interests_raw = interests_raw.where(user: @user)
        end

        interests = interests_raw.map do |interest_raw|
            user = {}
            user[:id] = interest_raw.user.id
            user[:name] = interest_raw.user.name
            user[:email] = interest_raw.user.email
            user[:phone] = interest_raw.user.phone
            user[:location] = { lat: interest_raw.user.location.lat, lng: interest_raw.user.location.lng, address: interest_raw.user.location.address }
            user[:authorized] = interest_raw.show_information
            {
                id: interest_raw.id,
                user:,
                pet: get_pet_info(interest_raw.pet),
                accepted: interest_raw.show_information
            }
        end

        render json: interests, status: :ok
    end

    # GET /interest/:id
    def show
        begin
            @interest = Interest.find(params[:id])
        rescue ActiveRecord::RecordNotFound
            render json: { errors: 'interest not found' }, status: :not_found
            return
        end

        user = {}
        user[:id] = @interest.user.id
        user[:name] = @interest.user.name
        user[:email] = @interest.user.email
        user[:phone] = @interest.user.phone
        user[:location] = { lat: @interest.user.location.lat, lng: @interest.user.location.lng, address: @interest.user.location.address }
        user[:authorized] = @interest.show_information

        interest = {
                id: @interest.id,
                user:,
                pet: get_pet_info(@interest.pet),
                accepted: @interest.show_information
            }

        render json: interest, status: :ok
    end

    # POST /interest
    def create
        find_pet
        find_user
        interest = Interest.new(user: @user, pet: @pet, show_information: 0)

        if interest.save
            @response = { message: 'Interest sended successfully', id: interest.id }
            render json: @response, status: :created
        else
            errors = interest.errors.map { |error| { "#{error.attribute}" => error.full_message } }

            @response = { message: errors }
            render json: @response, status: :unprocessable_entity
        end
    end

    # PUT /interest/:id
    def update
        begin
            interest = Interest.find(params[:id])
        rescue ActiveRecord::RecordNotFound
            render json: { errors: 'interest not found' }, status: :not_found
        end

        if interest.update(show_information: 1)
            @response = { message: 'Interest updated successfully', id: interest.id }
            render json: @response, status: :created
        else
            errors = interest.errors.map { |error| { "#{error.attribute}" => error.full_message } }

            @response = { message: errors }
            render json: @response, status: :unprocessable_entity
        end
    end

    # DELETE /interested/:id
    def destroy
        begin
            interest = Interest.find(params[:id])
        rescue ActiveRecord::RecordNotFound
            render json: { errors: 'interest not found' }, status: :not_found
        end

        if interest.destroy
            @response = { message: 'Interest removed successfully' }
            render json: @response, status: :ok
        else
            errors = interest.errors.map { |error| { "#{error.attribute}" => error.full_message } }

            @response = { message: errors }
            render json: @response, status: :unprocessable_entity
        end
    end

    private

    def find_pet
        @pet = Pet.find(params[:petId])
    rescue ActiveRecord::RecordNotFound
        render json: { errors: 'Pet not found' }, status: :not_found
    end

    def find_user
        @user = User.find(params[:userId])
      rescue ActiveRecord::RecordNotFound
        render json: { errors: 'User not found' }, status: :not_found
    end

    def authorize_user
        render json: { error: 'unauthorized' }, status: :unauthorized unless @current_user.id == @user.id
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
